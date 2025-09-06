import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor implements Interceptor {
  final FlutterSecureStorage _secureStorage;
   
  AuthInterceptor({required FlutterSecureStorage storage}) :_secureStorage = storage; 
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuth = options.extra['auth'] ?? false;
    if (isAuth) {
      final token = await _secureStorage.read(key: ChatConstants.KEY_SECURITY);
      if (token == null) {
        // Deslogar o usuario
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Expire Token',
            type: DioExceptionType.badResponse,
          ),
        );
      }

      options.headers['Authorization'] = 'Bearer $token';
    }else{
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
       handler.next(err);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
      handler.next(response);
  }

  

 
}
