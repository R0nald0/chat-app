import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/data/dto/chat_response_dto.dart';
import 'package:dio/dio.dart';

class ChatAuthRestClient {
  late Dio _dio;


  ChatAuthRestClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ChatConstants.BASE_URL,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
      ),
    );
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  ChatAuthRestClient auth() {
    _dio.options.extra['auth'] = true;
    return this;
  }

  ChatAuthRestClient unAuth() {
    _dio.options.extra['auth'] = false;
    return this;
  }

  Future<ChatResponseDto> login(
    ({String email, String password}) record,
  ) async {
    try {
      final Response(:data) = await _dio.post(
        '/auth/login',
        data: {'email': record.email, 'password': record.password},
      );
      return ChatResponseDto.fromMap(data);
    } on DioException catch (e, s) {
      log('erro ao logar usuário', error:  e, stackTrace:  s);
      throw DataSourceException( message: "erro ao logar usuário" ,statusCode:  e.response?.statusCode);
    }on ArgumentError catch (e,s){
       log('Json invalido', error:  e, stackTrace:  s);
      throw DataSourceException( message: "Json invalido");
    }
  }
  Future<String> register(
    ({String email,String name, String password, String passwordConfirmation,String imageUrl}) record,
  ) async {
    try {
      final Response(:data) = await _dio.post(
        '/auth/register',
        data: {
          'email': record.email, 
          'name' : record.name,
          'password': record.password,
          'password_confirmation' : record.passwordConfirmation,
          'image_url' : record.imageUrl
          },
      );
      return  data['message'];
    } on DioException catch (e, s) {
      log('erro ao registrar usuário', error:  e, stackTrace:  s);
      throw DataSourceException( message: "erro ao logar registrar" ,statusCode:  e.response?.statusCode);
    }on ArgumentError catch (e,s){
       log('Json invalido', error:  e, stackTrace:  s);
      throw DataSourceException( message: "Json invalido");
    }
  }
}
