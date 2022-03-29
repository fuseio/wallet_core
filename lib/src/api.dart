library api;

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class StudioApi {
  late Dio _dio;

  StudioApi({
    required String apiKey,
    bool enableLogging = false,
    String baseUrl = 'https://studio.fuse.io/api',
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        queryParameters: {
          'apiKey': apiKey,
        },
        headers: {"Content-Type": 'application/json'},
      ),
    );
    if (enableLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }
  }

  Future<dynamic> getCommunityData(
    String communityAddress, {
    String? walletAddress,
  }) async {
    String url = walletAddress != null
        ? '/v1/communities/$communityAddress/$walletAddress'
        : '/v1/communities/$communityAddress';
    Response response = await _dio.get(
      url,
    );

    return response.data['data'];
  }

  Future<dynamic> getBusinessList(
    String communityAddress,
  ) async {
    Response response = await _dio.get(
      '/v1/entities/$communityAddress',
      queryParameters: {
        'type': 'business',
        'withMetadata': true,
      },
    );

    return response.data;
  }

  Future<dynamic> getEntityMetadata(
    String communityAddress,
    String account, {
    bool isRopsten = false,
  }) async {
    Response response = await _dio.get(
      '/v1/entities/metadata/$communityAddress/$account',
    );

    return response.data['data'];
  }

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
      '/v1/images',
      data: formData,
    );

    return response.data;
  }

  Future<dynamic> fetchMetadata(
    String uri,
  ) async {
    Response response = await _dio.get(
      '/v1/metadata/$uri',
    );

    return response.data['data'];
  }
}
