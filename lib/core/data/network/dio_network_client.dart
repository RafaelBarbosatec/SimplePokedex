import 'package:dio/dio.dart';
import 'package:simple_pokedex/core/data/network/network_client.dart';
import 'package:simple_pokedex/core/data/network/network_error.dart';
import 'package:simple_pokedex/core/data/network/network_response.dart';

class DioNetworkProvider implements NetworkClient {
  late Dio _dio;
  final String baseUrl;

  DioNetworkProvider({required this.baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters).then((value) {
      return NetworkResponse<T>(
        data: value.data,
        headers: value.headers.map,
        statusCode: value.statusCode,
      );
    }).catchError((error) {
      if (error is DioError) {
        throw NetworkError(
          error: error.error,
          response: NetworkResponse<T>(
            data: error.response?.data,
            headers: error.response?.headers.map,
            statusCode: error.response?.statusCode,
          ),
        );
      } else {
        throw error;
      }
    });
  }
}
