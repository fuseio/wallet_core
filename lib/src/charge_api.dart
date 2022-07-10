library charge_api;

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' show basename;
import 'package:wallet_core/constants/enum.dart';
import 'package:wallet_core/models/models.dart';
import 'package:wallet_core/src/web3.dart';

class ChargeApi {
  late String _jwtToken;
  late Dio _dio;

  ChargeApi(
    String publicApiKey, {
    String baseUrl = 'https://api.chargeweb3.com/api',
    List<Interceptor> interceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'apiKey': publicApiKey,
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

  Future<dynamic> uploadImage(
    File imageFile,
  ) async {
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    });
    Response response = await _dio.post(
      '/v0/studio/images',
      data: formData,
    );

    return response.data;
  }

  // End of studio API's

  // Start of Wallet API's

  // Login using Firebase
  Future<String> loginWithFirebase(
    String token,
    String accountAddress,
    String identifier, {
    String? appName,
  }) async {
    Response response = await _dio.post(
      '/v0/wallets/login/firebase/verify',
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
      '/v0/wallets/login/sms/request',
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
      '/v0/wallets/login/sms/verify',
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
      '/v0/wallets/login/request',
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
    String? referralAddress,
  }) async {
    dynamic wallet = await getWallet();
    if (wallet != null && wallet['walletAddress'] != null) {
      print('Wallet already exists - wallet: $wallet');
      return wallet;
    }
    Response response = await _dio.post(
      '/v0/wallets/wallets',
      data: {
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
      '/v0/wallets/wallets',
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
      '/v0/wallets/wallets/actions/$walletAddress',
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
      '/v0/wallets/wallets/actions/paginated/$walletAddress',
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
      '/v0/wallets/wallets/upgrades/available/$walletAddress',
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
      '/v0/wallets/wallets/upgrades/install/$walletAddress',
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
      '/v0/wallets/wallets/apy/reward/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> claimReward(
    String walletAddress,
  ) async {
    Response response = await _dio.post(
      '/v0/wallets/wallets/apy/claim/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> enableWalletApy(
    String walletAddress,
  ) async {
    Response response = await _dio.post(
      '/v0/wallets/wallets/apy/enable/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> getJob(String id) async {
    Response response = await _dio.get(
      '/v0/jobs/$id',
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
      '/v0/wallets/wallets/$phoneNumber',
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
      '/v0/wallets/wallets/token/$walletAddress',
      data: {'firebaseToken': firebaseToken},
      options: options,
    );
    return response.data;
  }

  Future<dynamic> addUserContext(
    Map<dynamic, dynamic> body,
  ) async {
    Response response = await _dio.put(
      '/v0/wallets/wallets/context',
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
      '/v0/wallets/wallets/token/$walletAddress/delete',
      data: {'firebaseToken': firebaseToken},
      options: options,
    );
    return response.data;
  }

  Future<dynamic> backupWallet() async {
    Response response = await _dio.post(
      '/v0/wallets/wallets/backup',
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
      '/v0/wallets/relay',
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
      '/v0/wallets/relay',
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
      '/v0/wallets/relay',
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
      '/v0/wallets/relay',
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
      '/v0/wallets/relay',
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
      '/v0/wallets/relay',
      options: options,
      data: signedData,
    );

    return response.data;
  }

  Future<dynamic> multiRelay(
    List<dynamic> items,
  ) async {
    Response response = await _dio.post(
      '/v0/wallets/relay/multi',
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
      '/v0/wallets/contacts',
      data: {'contacts': phoneNumbers},
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> ackSync(
    int nonce,
  ) async {
    Response response = await _dio.post(
      '/v0/wallets/contacts/$nonce',
      options: options,
    );

    return response.data;
  }

  Future<dynamic> invite(
    String phoneNumber, {
    String name = '',
    String amount = '',
    String symbol = '',
  }) async {
    Response response = await _dio.post(
      '/v0/wallets/wallets/invite/$phoneNumber',
      data: {
        'name': name,
        'amount': amount,
        'symbol': symbol,
      },
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getReferralInfo(
    String walletAddress,
  ) async {
    Response response = await _dio.get(
      '/v0/wallets/wallets/referral/total/$walletAddress',
      options: options,
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getUserProfile(
    String walletAddress,
  ) async {
    Response response = await _dio.get(
      '/v0/wallets/wallets/profiles/$walletAddress',
      options: options,
    );

    return response.data['data'];
  }

  Future<dynamic> saveUserProfile(
    Map body,
  ) async {
    Response response = await _dio.post(
      '/v0/wallets/wallets/profiles',
      data: body,
      options: options,
    );

    return response.data;
  }

  Future<dynamic> updateAvatar(
    String accountAddress,
    String avatarHash,
  ) async {
    Response response = await _dio.put(
      '/v0/wallets/wallets/profiles/$accountAddress/avatar',
      data: {'avatarHash': avatarHash},
      options: options,
    );

    return response.data;
  }

  Future<dynamic> updateDisplayName(
    String accountAddress,
    String displayName,
  ) async {
    Response response = await _dio.put(
      '/v0/wallets/wallets/profiles/$accountAddress/name',
      data: {'displayName': displayName},
      options: options,
    );

    return response.data;
  }

  // End of Wallet API's

  // Start of Voltage API's

  Future<SwapRequestParametersData> requestParameters(
    TradeRequestBody swapRequestBody,
  ) async {
    Response response = await _dio.post(
      '/v0/trade/swap/requestparameters',
      data: swapRequestBody.toJson(),
    );
    return SwapRequestParametersData.fromJson(response.data);
  }

  Future<Trade> quote(
    TradeRequestBody swapRequestBody,
  ) async {
    Response response = await _dio.post(
      '/v0/trade/swap/quote',
      data: swapRequestBody.toJson(),
    );
    if (response.data['error'] != null) {
      throw response.data['error']['message'];
    }
    return Trade.fromJson(response.data['data']['info']);
  }

  Future<String> price(
    String tokenAddress, {
    String currency = 'usd',
  }) async {
    Response response = await _dio.get(
      '/v0/trade/price/$tokenAddress',
    );
    return response.data['data']['price'] ?? '0';
  }

  Future<String> priceChange(
    String tokenAddress,
  ) async {
    Response response = await _dio.get(
      '/v0/trade/pricechange/$tokenAddress',
    );
    return response.data['data']['priceChange'] ?? '0';
  }

  Future<List<ChartItem>> interval(
    String tokenAddress,
    TimeFrame timeFrame,
  ) async {
    Response response = await _dio.get(
      '/v0/trade/pricechange/interval/${timeFrame.name.toUpperCase()}/$tokenAddress',
    );
    return (response.data['data'] as List<dynamic>)
        .map((stats) => ChartItem.fromJson(stats))
        .toList();
  }
  // End of Voltage API's
}
