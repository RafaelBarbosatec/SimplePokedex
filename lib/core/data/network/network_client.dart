import 'package:simple_pokedex/core/data/network/network_response.dart';

abstract class NetworkClient {
  Future<NetworkResponse<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
  });
}
