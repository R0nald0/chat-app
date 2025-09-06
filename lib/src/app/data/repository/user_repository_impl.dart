import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/data/datasource/chat_user_rest_client.dart';
import 'package:chat/src/app/data/dto/user_dto.dart';
import 'package:chat/src/app/domain/repository/user_repository.dart';
import 'package:chat/src/app/domain/model/user.dart';

class UserRepositoryImpl implements UserRepository {
  final ChatUserRestClient _userRestClient;
  UserRepositoryImpl({required ChatUserRestClient userRestClient})
    : _userRestClient = userRestClient;

  @override
  Future<User> findUserbyEmail(String emailToSearch) async {
    try {
      final UserDto(:name, :email, :id, imageUrl:urlImage) = await _userRestClient.auth().findByEmail(
        emailToSearch,
      );
      return User( id:id ,name: name, email: email, password: '',urlImage:urlImage );
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }on UserNotFound  {
      rethrow;
    }
  }
}
