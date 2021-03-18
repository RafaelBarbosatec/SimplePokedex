import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_pokedex/core/data/network/network_client.dart';
import 'package:simple_pokedex/core/data/network/network_error.dart';
import 'package:simple_pokedex/core/data/network/network_response.dart';

class DioNetworkClient implements NetworkClient {
  Dio _dio;
  final String baseUrl;

  DioNetworkClient({@required this.baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters).then((value) {
      return NetworkResponse(
        data: value.data,
        headers: value.headers.map,
        statusCode: value.statusCode,
      );
    }).catchError((error) {
      if (error is DioError) {
        throw NetworkError(
          error: error.error,
          response: NetworkResponse(
            data: error.response?.data,
            headers: error.response?.headers?.map,
            statusCode: error.response?.statusCode,
          ),
        );
      } else {
        throw error;
      }
    });
  }
}
