import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/data/datasource/chat_auth_rest_client.dart';
import 'package:chat/src/app/data/dto/chat_response_dto.dart';
import 'package:chat/src/app/domain/repository/auth_repository.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ChatAuthRestClient _restClient;
  final FlutterSecureStorage _storage;
//  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  AuthRepositoryImpl({required ChatAuthRestClient chatRestClient, required  FlutterSecureStorage storage})
    : _restClient = chatRestClient ,_storage = storage;

  @override
  Future<User> login(({String email, String password}) data) async {
    try {
     final prefs = await  SharedPreferences.getInstance();
      final ChatResponseDto(:user, :token) = await _restClient.unAuth().login(data);
      
       await _storage.write(key: ChatConstants.KEY_SECURITY, value: token, 
       );
       final isSaved  = await prefs.setString(ChatConstants.PREF_KEY, user.toJson());
       
      if (!isSaved) {
        _storage.delete(key: ChatConstants.KEY_SECURITY);
        throw RepositoryException(message: 'Erro ao salvar dados do usuário realizar o login novamente');
      }
 
      return user;
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<String> register(
    ({String email, String name, String password, String passwordConfirmation,String imageUrl})
    data,
  ) async {
    try {
      return await _restClient.unAuth().register(data);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
}
