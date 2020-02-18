import 'dart:io';

import 'package:dio/dio.dart';

class Con {
  final String urlBase;
  final bool debug;
  Dio _dio;
  Con(this.urlBase, {this.debug = false}) {
    _dio = Dio();
    _dio.options.baseUrl = urlBase;
  }

  void addInterceptor(InterceptorsWrapper interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// Método que executa chamada de conexão do tipo GET
  /// @params uri
  /// @params headers (opcional)
  Future<dynamic> get(String uri,
      {Map<String, String> headers,
      Map<String, dynamic> queryParameters}) async {
    Response response;

    try {
      if (debug)
        print("[${DateTime.now().toString()}] GET($uri) --> $queryParameters");
      final op = Options(headers: headers);
      response =
          await _dio.get(uri, options: op, queryParameters: queryParameters);
      if (debug)
        print("[${DateTime.now().toString()}] GET($uri) <-- $response");
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw new ResponseErrorException("Without Internet", 0);
      }

      int statusCode = e.response.statusCode;

      if (statusCode == 401) {
        throw new UnauthorizedException(e.response.data.toString());
      }
      throw new ResponseErrorException(
          e.response.data.toString(), e.response.statusCode);
    }

    return response.data;
  }

  /// Método que executa chamada de conexão do tipo POST
  /// @params uri
  /// @params body
  /// @params headers (opcional)
  Future<dynamic> post(String uri, dynamic body,
      {Map<String, String> headers}) async {
    Response response;

    try {
      if (debug) print("[${DateTime.now().toString()}] POST($uri) --> $body");
      final op = Options(headers: headers);
      response = await _dio.post(uri, data: body, options: op);
      if (debug)
        print("[${DateTime.now().toString()}] POST($uri) <-- $response");
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw new ResponseErrorException("Without Internet", 0);
      }

      int statusCode = e.response.statusCode;

      if (statusCode == 401) {
        throw new UnauthorizedException(e.response.data.toString());
      }
      throw new ResponseErrorException(
          e.response.data.toString(), e.response.statusCode);
    }

    return response.data;
  }

  /// Método que executa chamada de conexão do tipo PUT
  /// @params uri
  /// @params body
  /// @params headers (opcional)
  Future<dynamic> put(String uri, dynamic body,
      {Map<String, String> headers}) async {
    Response response;

    try {
      if (debug) print("[${DateTime.now().toString()}] PUT($uri) --> $body");
      final op = Options(headers: headers);
//      op.contentType = "application/x-www-form-urlencoded";
      response = await _dio.put(uri, data: body, options: op);
      if (debug)
        print("[${DateTime.now().toString()}] PUT($uri) <-- $response");
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw new ResponseErrorException("Without Internet", 0);
      }

      int statusCode = e.response.statusCode;

      if (statusCode == 401) {
        throw new UnauthorizedException(e.response.data.toString());
      }
      throw new ResponseErrorException(
          e.response.data.toString(), e.response.statusCode);
    }

    return response.data;
  }

  /// Método que executa chamada de conexão do tipo DELETE
  /// @params uri
  /// @params headers (opcional)
  Future<dynamic> delete(String uri, {Map<String, String> headers}) async {
    Response response;

    try {
      if (debug) print("[${DateTime.now().toString()}] DELETE($uri)");
      final op = Options(headers: headers);
      response = await _dio.delete(uri, options: op);
      if (debug)
        print("[${DateTime.now().toString()}] DELETE($uri) <-- $response");
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw new ResponseErrorException("Without Internet", 0);
      }

      int statusCode = e.response.statusCode;

      if (statusCode == 401) {
        throw new UnauthorizedException(e.response.data.toString());
      }
      throw new ResponseErrorException(
          e.response.data.toString(), e.response.statusCode);
    }

    return response.data;
  }
}

class UnauthorizedException implements Exception {
  final String msg;

  UnauthorizedException(this.msg);

  @override
  String toString() {
    return 'UnauthorizedException{msg: $msg}';
  }
}

class ResponseErrorException implements Exception {
  final String error;
  final int code;

  ResponseErrorException(this.error, this.code);

  @override
  String toString() {
    return 'ResponseErroException{error: $error}';
  }
}
