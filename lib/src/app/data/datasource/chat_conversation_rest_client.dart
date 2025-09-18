import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/rest_client/interceptors/auth_interceptor.dart';
import 'package:chat/src/app/data/dto/conversation_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatConversationRestClient {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  ChatConversationRestClient({required FlutterSecureStorage storage})
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

  ChatConversationRestClient auth() {
    _dio.options.extra['auth'] = true;
    return this;
  }

  ChatConversationRestClient unAuth() {
    _dio.options.extra['auth'] = false;
    return this;
  }

  Future<int?> createConversation(
    ({int contactId, String subject, String message}) conversationData,
  ) async {
    try {
      final Response(:data) = await _dio.post(
        '/conversation',
        data: {
          "contact_id": conversationData.contactId,
          "subject": conversationData.subject,
          "message": conversationData.message,
        },
      );
      return data['id'] as int?;
      
    } on DioException catch (e, s) {
      log('erro ao buscar conversas ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar conversas ",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<int?> findConversationByContactId(int idContact) async {
    try {
      final Response(:data) = await _dio.get('/conversation/$idContact');
      return data['id'] as int?;
    } on DioException catch (e, s) {
      log('erro ao buscar conversas ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar conversas ",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<List<ConversationDto>> findAll(int userId) async {
    try {
      final Response(data: List result) = await _dio.get(
        '/conversation/',
        queryParameters: {'id': userId},
      );

      return result
          .map<ConversationDto>((cdto) => ConversationDto.fromMap(cdto))
          .toList();
    } on DioException catch (e, s) {
      log('erro ao buscar conversas ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar conversas ",
        statusCode: e.response?.statusCode,
      );
    } on ArgumentError catch (e, s) {
      log('Json invalido', error: e, stackTrace: s);
      throw DataSourceException(message: "Json invalido");
    }
  }

  Future<ConversationDto> updateReadConersationMessasge(
    int idConversation,
  ) async {
    try {
      final Response(:data) = await _dio.put(
        '/readConversatio/$idConversation',
      );
      return ConversationDto.fromMap(data);
    } on DataSourceException catch (e, s) {
      log('erro ao buscar conversas ', error: e, stackTrace: s);
      throw DataSourceException(
        message: "erro ao buscar conversas ",
        statusCode: e.statusCode,
      );
    }
  }
}
