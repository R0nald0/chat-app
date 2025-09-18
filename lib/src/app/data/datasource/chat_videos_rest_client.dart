import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/rest_client/interceptors/auth_interceptor.dart';
import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatVideosRestClient {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  ChatVideosRestClient({required FlutterSecureStorage storage})
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

  ChatVideosRestClient auth() {
    _dio.options.extra['auth'] = true;
    return this;
  }

  ChatVideosRestClient unAuth() {
    _dio.options.extra['auth'] = false;
    return this;
  }

  Future<List<StoryDto>> findStoryMyContacts(int id) async {
    try {
      final Response(data: List result) = await _dio.get('/users/videos/$id');

      return result.map<StoryDto>((u) => StoryDto.fromMap(u)).toList();
    } on DioException catch (e, s) {
      log('erro ao buscar videos do contato ', error: e, stackTrace: s);
      throw DataSourceException();
    } on ArgumentError catch (e, s) {
      log('Json invalido', error: e, stackTrace: s);
      throw DataSourceException(message: "Json invalido");
    }
  }

  Future<Video> createVideo(
    ({
      String owneriId,
      String description,
      double duration,
      bool privateVideo,
      String urlVideo,
    })
    dataVideo,
  ) async {
    try {
      final Response(:data) = await _dio.get(
        '/videos',
        data: {
          "description": dataVideo.description,
          "duration": dataVideo.duration,
          "urlVideo": dataVideo.urlVideo,
          "ownerId": dataVideo.owneriId,
          "private": dataVideo.privateVideo,
        },
      );

      return Video.fromMap(data);
    } on DioException catch (e, s) {
      log('erro ao criar video  ', error: e, stackTrace: s);
      throw DataSourceException();
    } on ArgumentError catch (e, s) {
      log('Json invalido', error: e, stackTrace: s);
      throw DataSourceException(message: "Json invalido");
    }
  }
}
