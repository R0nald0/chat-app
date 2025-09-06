import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/core/rest_client/interceptors/auth_interceptor.dart';
import 'package:chat/src/app/data/dto/user_dto.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatUserRestClient {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  ChatUserRestClient({required FlutterSecureStorage storage})
    : _secureStorage = storage {
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

  ChatUserRestClient auth() {
    _dio.options.extra['auth'] = true;
    return this;
  }

  ChatUserRestClient unAuth() {
    _dio.options.extra['auth'] = false;
    return this;
  }

  Future<UserDto> findByEmail(String email) async {
    try {
      final Response(:data) = await _dio.get(
       '/users',
        queryParameters: {'email': email},
      );

      return UserDto.fromMap(data);
    } on DioException catch (e, s) {
      if (e.response?.statusCode == 404) {
        log('erro ao buscar dados do contato ', error: e, stackTrace: s);
          throw UserNotFound();
      }
      log('erro ao buscar dados do contato ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar dados do contatos ",
        statusCode: e.response?.statusCode,
      );
    } on ArgumentError catch (e, s) {
      log('Json invalido', error: e, stackTrace: s);
      throw DataSourceException(message: "Json invalido");
    }
  }
}
