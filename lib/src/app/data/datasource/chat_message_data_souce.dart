
import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/rest_client/interceptors/auth_interceptor.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatMessageDataSouce {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ChatMessageDataSouce({required FlutterSecureStorage sercureStorage})
    : _secureStorage = sercureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: ChatConstants.BASE_URL,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
      ),
    );
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      AuthInterceptor(storage: _secureStorage),
    ]);
  }

  ChatMessageDataSouce auth() {
    _dio.options.extra['auth'] = true;
    return this;
  }

  ChatMessageDataSouce unAuth() {
    _dio.options.extra['auth'] = false;
    return this;
  }

  Future<List<Message>> findAll(int conversationId) async {
    try {
      final Response(data: List result) = await _dio.get(
        '/messages',
        queryParameters: {'id_conversation': conversationId},
      );

      return result.map<Message>((m) => Message.fromMap(m)).toList();
    } on DioException catch (e, s) {
      log('erro ao buscar messages ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar messages ",
        statusCode: e.response?.statusCode,
      );
    } on ArgumentError catch (e, s) {
      log('Json invalido', error: e, stackTrace: s);
      throw DataSourceException(message: "Json invalido");
    }
  }
}
