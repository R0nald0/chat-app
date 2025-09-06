
import 'package:chat/src/app/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  Future<String> call(({String email,String name, String password, String passwordConfirmation,String imageUrl}) data) => _authRepository.register(data);
}