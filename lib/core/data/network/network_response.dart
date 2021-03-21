import 'dart:convert';

class NetworkResponse<T> {
  NetworkResponse({
    this.data,
    this.headers,
    this.statusCode,
  });

  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;

  /// Response headers.
  Map<String, List<String>>? headers;

  /// Http status code.
  int? statusCode;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    String body;
    if (data is Map) {
      body = json.encode(data);
    }
    body = data.toString();
    return 'NetworkResponse{statusCode: $statusCode body:$body headers: $headers }';
  }
}
