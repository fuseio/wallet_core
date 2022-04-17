library api;

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:wallet_core/src/web3.dart';

class WalletApi {
  late String _jwtToken;
  late Dio _dio;

  WalletApi({
    String baseUrl = 'https://wallet.fuse.io/api',
    List<Interceptor> interceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  void setJwtToken(String value) {
    _jwtToken = value;
  }

  Options get options => Options(
        headers: {
          'Authorization': 'Bearer $_jwtToken',
        },
      );

  // Login using Firebase
  Future<String> loginWithFirebase(
    String token,
    String accountAddress,
    String identifier, {
    String? appName,
  }) async {
    Response response = await _dio.post(
      '/v1/login/firebase/verify',
      data: {
        'token': token,
        'accountAddress': accountAddress,
        'identifier': identifier,
        'appName': appName,
      },
    );
    if (response.data['token'] != '') {
      _jwtToken = response.data['token'];
      return response.data['token'];
    } else {
      throw 'Error! Login verify failed - accountAddress: $accountAddress, token: $token, identifier: $identifier';
    }
  }

  // Login using sms
  Future<bool> loginWithSMS(
    String phoneNumber,
  ) async {
    Response response = await _dio.post(
      '/v1/login/sms/request',
      data: {
        'phoneNumber': phoneNumber,
      },
    );
    if (response.data['response'] == 'ok') {
      return true;
    } else {
      throw 'Error! Login request failed - phoneNumber: $phoneNumber';
    }
  }

  // Verify using sms
  Future<String> verifySMS(
    String verificationCode,
    String phoneNumber,
    String accountAddress, {
    String? appName,
  }) async {
    Response response = await _dio.post(
      '/v1/login/sms/verify',
      data: {
        'code': verificationCode,
        'phoneNumber': phoneNumber,
        'accountAddress': accountAddress,
        'appName': appName,
      },
    );
    if (response.data['token'] != '') {
      _jwtToken = response.data['token'];
      return response.data['token'];
    } else {
      throw 'Error! Login verify failed - phoneNumber: $phoneNumber, verificationCode: $verificationCode';
    }
  }

  // Request token
  Future<String> requestToken(
    String phoneNumber,
    String accountAddress, {
    String? appName,
  }) async {
    Response response = await _dio.post(
      '/v1/login/request',
      data: {
        'phoneNumber': phoneNumber,
        'accountAddress': accountAddress,
        'appName': appName,
      },
    );
    if (response.data['token'] != '') {
      _jwtToken = response.data['token'];
      return response.data['token'];
    } else {
      throw 'Error! Login verify failed - phoneNumber: $phoneNumber';
    }
  }

  Future<dynamic> createWallet({
    String? communityAddress,
    String? referralAddress,
  }) async {
    dynamic wallet = await getWallet();
    if (wallet != null && wallet['walletAddress'] != null) {
      print('Wallet already exists - wallet: $wallet');
      return wallet;
    }
    Response response = await _dio.post(
      '/v1/wallets',
      data: {
        'communityAddress': communityAddress,
        'referralAddress': referralAddress,
      },
      options: options,
    );
    if (response.data['job'] != null) {
      return response.data;
    } else {
      throw 'Error! Create wallet request failed';
    }
  }

  Future<dynamic> getWallet() async {
    Response response = await _dio.get(
      '/v1/wallets',
      options: options,
    );
    if (response.data['data'] != null) {
      final Map<String, dynamic> data = response.data['data'];
      return {
        'phoneNumber': data['phoneNumber'],
        'accountAddress': data['accountAddress'],
        'walletAddress': data['walletAddress'],
        'createdAt': data['createdAt'],
        'updatedAt': data['updatedAt'],
        'walletModules': data['walletModules'],
        'communityManager': data['walletModules']['CommunityManager'],
        'transferManager': data['walletModules']['TransferManager'],
        'dAIPointsManager': data['walletModules']['DAIPointsManager'] ?? null,
        'networks': data['networks'],
        'backup': data['backup'],
        'balancesOnForeign': data['balancesOnForeign'],
        'apy': data['apy'],
        'version': data['version'],
        'paddedVersion': data['paddedVersion'],
        'isBlacklisted': data['isBlacklisted'] ?? false,
      };
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>> getActionsByWalletAddress(
    String walletAddress, {
    int updatedAt = 0,
    String? tokenAddress,
  }) async {
    Response response = await _dio.get(
      '/v1/wallets/actions/$walletAddress',
      queryParameters: {
        'updatedAt': updatedAt,
        'tokenAddress': tokenAddress,
      },
      options: options,
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getPaginatedActionsByWalletAddress(
    String walletAddress,
    int pageIndex, {
    String? tokenAddress,
  }) async {
    Response response = await _dio.get(
      '/v1/wallets/actions/paginated/$walletAddress',
      queryParameters: {
        'page': pageIndex,
        'tokenAddress': tokenAddress,
      },
      options: options,
    );
    return response.data['data'];
  }

  Future<dynamic> getAvailableUpgrades(
    String walletAddress,
  ) async {
    Response response = await _dio.get(
      '/v1/wallets/upgrades/available/$walletAddress',
      options: options,
    );
    return response.data['data'];
  }

  Future<dynamic> installUpgrades(
    Web3 web3,
    String walletAddress,
    String disableModuleName,
    String disableModuleAddress,
    String enableModuleAddress,
    String upgradeId,
  ) async {
    Map<String, dynamic> relayParams = await web3.addModule(
      walletAddress,
      disableModuleName,
      disableModuleAddress,
      enableModuleAddress,
    );
    Response response = await _dio.post(
      '/v1/wallets/upgrades/install/$walletAddress',
      data: {
        'upgradeId': upgradeId,
        'relayParams': relayParams,
      },
      options: options,
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> getNextReward(
    String walletAddress,
  ) async {
    Response response = await _dio.get(
      '/v1/wallets/apy/reward/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> claimReward(
    String walletAddress,
  ) async {
    Response response = await _dio.post(
      '/v1/wallets/apy/claim/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> enableWalletApy(
    String walletAddress,
  ) async {
    Response response = await _dio.post(
      '/v1/wallets/apy/enable/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> getJob(String id) async {
    Response response = await _dio.get(
      '/v1/jobs/$id',
      options: options,
    );
    if (response.data['data'] != null) {
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<dynamic> getWalletByPhoneNumber(
    String phoneNumber,
  ) async {
    Response response = await _dio.get(
      '/v1/wallets/$phoneNumber',
      options: options,
    );
    if (response.data['data'] != null) {
      return {
        'phoneNumber': response.data['data']['phoneNumber'],
        'accountAddress': response.data['data']['accountAddress'],
        'walletAddress': response.data['data']['walletAddress'],
        'createdAt': response.data['data']['createdAt'],
        'updatedAt': response.data['data']['updatedAt']
      };
    } else {
      return {};
    }
  }

  Future<dynamic> updateFirebaseToken(
    String walletAddress,
    String firebaseToken,
  ) async {
    Response response = await _dio.put(
      '/v1/wallets/token/$walletAddress',
      data: {'firebaseToken': firebaseToken},
      options: options,
    );
    return response.data;
  }

  Future<dynamic> addUserContext(
    Map<dynamic, dynamic> body,
  ) async {
    Response response = await _dio.put(
      '/v1/wallets/context',
      data: body,
      options: options,
    );
    return response.data;
  }

  Future<dynamic> deleteFirebaseToken(
    String walletAddress,
    String firebaseToken,
  ) async {
    Response response = await _dio.put(
      '/v1/wallets/token/$walletAddress/delete',
      data: {'firebaseToken': firebaseToken},
      options: options,
    );
    return response.data;
  }

  Future<dynamic> backupWallet({
    String? communityAddress,
  }) async {
    Response response = await _dio.post(
      '/v1/wallets/backup',
      data: {'communityAddress': communityAddress},
      options: options,
    );
    return response.data;
  }

  Future<dynamic> joinCommunity(
    Web3 web3,
    String walletAddress,
    String communityAddress, {
    String? tokenAddress,
    String network = 'fuse',
    String? originNetwork,
    String? communityName,
  }) async {
    Map<String, dynamic> data = await web3.joinCommunityOffChain(
      walletAddress,
      communityAddress,
      tokenAddress: tokenAddress,
      network: network,
      originNetwork: originNetwork,
      communityName: communityName,
    );
    Response response = await _dio.post(
      '/v1/relay',
      data: data,
      options: options,
    );
    return response.data;
  }

  Future<dynamic> transfer(
    Web3 web3,
    String walletAddress,
    String receiverAddress, {
    String? tokensAmount,
    BigInt? amountInWei,
    String network = 'fuse',
    Map? transactionBody,
  }) async {
    Map<String, dynamic> data = await web3.transferOffChain(
      walletAddress,
      receiverAddress,
      tokensAmount: tokensAmount,
      amountInWei: amountInWei,
      network: network,
      transactionBody: transactionBody,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> nftTransfer(
    Web3 web3,
    String nftTransferContractAddress,
    String walletAddress,
    String contractAddress,
    String receiverAddress,
    num tokenId, {
    String network = 'fuse',
    Map? transactionBody,
  }) async {
    Map<String, dynamic> data = await web3.transferNFTOffChain(
      nftTransferContractAddress,
      walletAddress,
      contractAddress,
      receiverAddress,
      tokenId,
      network: network,
      transactionBody: transactionBody,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> tokenTransfer(
    Web3 web3,
    String walletAddress,
    String tokenAddress,
    String receiverAddress,
    String tokensAmount, {
    String network = 'fuse',
    String? externalId,
  }) async {
    Map<String, dynamic> data = await web3.transferTokenOffChain(
      walletAddress,
      tokenAddress,
      receiverAddress,
      tokensAmount,
      network: network,
      externalId: externalId,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> approveTokenTransfer(
    Web3 web3,
    String walletAddress,
    String tokenAddress, {
    String network = 'fuse',
    num? tokensAmount,
    BigInt? amountInWei,
  }) async {
    Map<String, dynamic> data = await web3.approveTokenOffChain(
      walletAddress,
      tokenAddress,
      tokensAmount: tokensAmount,
      amountInWei: amountInWei,
      network: network,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> transferDaiToDaiPointsOffChain(
    Web3 web3,
    String walletAddress,
    num tokensAmount,
    int tokenDecimals, {
    String? network,
  }) async {
    Map<String, dynamic> data = await web3.transferDaiToDAIpOffChain(
      walletAddress,
      tokensAmount,
      tokenDecimals,
      network: network,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> callContract(
    Web3 web3,
    String walletAddress,
    String contractAddress,
    String data, {
    String? network,
    num? ethAmount,
    BigInt? amountInWei,
    Map? transactionBody,
    Map? txMetadata,
  }) async {
    Map<String, dynamic> signedData = await web3.callContractOffChain(
      walletAddress,
      contractAddress,
      data,
      network: network,
      ethAmount: ethAmount,
      amountInWei: amountInWei,
      transactionBody: transactionBody,
      txMetadata: txMetadata,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: signedData,
    );
    return response.data;
  }

  Future<dynamic> approveTokenAndCallContract(
    Web3 web3,
    String walletAddress,
    String tokenAddress,
    String contractAddress,
    String data, {
    String? network,
    num? tokensAmount,
    BigInt? amountInWei,
    Map? transactionBody,
    Map? txMetadata,
  }) async {
    Map<String, dynamic> signedData =
        await web3.approveTokenAndCallContractOffChain(
      walletAddress,
      tokenAddress,
      contractAddress,
      data,
      amountInWei: amountInWei,
      tokensAmount: tokensAmount,
      network: network,
      transactionBody: transactionBody,
      txMetadata: txMetadata,
    );
    Response response = await _dio.post(
      '/v1/relay',
      options: options,
      data: signedData,
    );

    return response.data;
  }

  Future<dynamic> multiRelay(
    List<dynamic> items,
  ) async {
    Response response = await _dio.post(
      '/v1/relay/multi',
      options: options,
      data: {
        'items': items,
      },
    );

    return response.data;
  }

  Future<dynamic> syncContacts(
    List<String> phoneNumbers,
  ) async {
    Response response = await _dio.post(
      '/v1/contacts',
      data: {'contacts': phoneNumbers},
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> ackSync(int nonce) async {
    Response response = await _dio.post(
      '/v1/contacts/$nonce',
      options: options,
    );

    return response.data;
  }

  Future<dynamic> invite(
    String phoneNumber, {
    String communityAddress = '',
    String name = '',
    String amount = '',
    String symbol = '',
  }) async {
    Response response = await _dio.post(
      '/v1/wallets/invite/$phoneNumber',
      data: {
        'communityAddress': communityAddress,
        'name': name,
        'amount': amount,
        'symbol': symbol,
      },
      options: options,
    );
    return response.data;
  }

  Future<dynamic> transferTokenToHomeWithAMBBridge(
    Web3 web3,
    String walletAddress,
    String foreignBridgeMediator,
    String tokenAddress,
    num tokensAmount,
    int tokenDecimals, {
    String network = 'mainnet',
  }) async {
    List<dynamic> signData = await web3.transferTokenToHome(
      walletAddress,
      foreignBridgeMediator,
      tokenAddress,
      tokensAmount,
      tokenDecimals,
      network: network,
    );
    Map<String, dynamic> resp = await multiRelay(
      signData,
    );
    return resp;
  }

  Future<dynamic> transferTokenToForeignWithAMBBridge(
    Web3 web3,
    String walletAddress,
    String homeBridgeMediatorAddress,
    String tokenAddress,
    num tokensAmount,
    int tokenDecimals, {
    String network = 'fuse',
  }) async {
    List<dynamic> signData = await web3.transferTokenToForeign(
      walletAddress,
      homeBridgeMediatorAddress,
      tokenAddress,
      tokensAmount,
      tokenDecimals,
      network: network,
    );
    Map<String, dynamic> resp = await multiRelay(
      signData,
    );
    return resp;
  }

  Future<Map<String, dynamic>> getBeaconByWalletAddress(
    String walletAddress,
  ) async {
    String url = '/v1/wallets/beacons/$walletAddress';
    Response response = await _dio.post(
      url,
      options: options,
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getWalletAddressByMajorAndMonirIds(
    int major,
    int minor,
  ) async {
    String url = '/v1/wallets/beacons/$major/$minor';
    Response response = await _dio.get(
      url,
      options: options,
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getReferralInfo(
    String walletAddress,
  ) async {
    Response response = await _dio.get(
      '/v1/wallets/referral/total/$walletAddress',
      options: options,
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getUserProfile(
    String walletAddress,
  ) async {
    String url = '/v1/wallets/profiles/$walletAddress';
    Response response = await _dio.get(
      url,
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> saveUserProfile(Map body) async {
    String url = '/v1/wallets/profiles';
    Response response = await _dio.post(
      url,
      data: body,
      options: options,
    );

    return response.data;
  }

  Future<dynamic> updateAvatar(
    String accountAddress,
    String avatarHash,
  ) async {
    String url = '/v1/wallets/profiles/$accountAddress/avatar';
    Response response = await _dio.put(
      url,
      data: {'avatarHash': avatarHash},
      options: options,
    );

    return response.data;
  }

  Future<dynamic> updateDisplayName(
    String accountAddress,
    String displayName,
  ) async {
    String url = '/v1/wallets/profiles/$accountAddress/name';
    Response response = await _dio.put(
      url,
      data: {'displayName': displayName},
      options: options,
    );

    return response.data;
  }
}
