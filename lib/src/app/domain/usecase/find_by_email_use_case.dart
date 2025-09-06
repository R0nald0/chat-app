
import 'package:chat/src/app/domain/repository/user_repository.dart';
import 'package:chat/src/app/domain/model/user.dart';

class FindByEmailUseCase {
  final UserRepository _userRepository;
  FindByEmailUseCase({required UserRepository userRepository}):_userRepository = userRepository;
  Future<User> call(String email) => _userRepository.findUserbyEmail(email);
}