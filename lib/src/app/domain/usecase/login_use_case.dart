import 'package:chat/src/app/domain/repository/auth_repository.dart';
import 'package:chat/src/app/domain/model/user.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  Future<User> call(({String email, String password}) data) => _authRepository.login(data);
}
