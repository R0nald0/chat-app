
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  LogoutUseCase({required AuthRepository authRepository}):_authRepository = authRepository;
  Future<User?> call() => _authRepository.logout();
}