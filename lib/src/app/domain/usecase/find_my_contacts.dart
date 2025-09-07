import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/repository/user_repository.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';

class FindMyContacts {
  final UserRepository _userRepository;
  final FindMyUseCase _findMyUseCase;

  FindMyContacts({
    required UserRepository userRepository,
    required FindMyUseCase findMyUseCase,
  }) : _userRepository = userRepository,
       _findMyUseCase = findMyUseCase;

  Future<List<User>> call() async {
    try {
      final user = await _findMyUseCase();
      return _userRepository.findMyContacts(user.id!);
    } on RepositoryException  {
       rethrow;
    } on UserNotFound {
      rethrow;
    }
  }
}
