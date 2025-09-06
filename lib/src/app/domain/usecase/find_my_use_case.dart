
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/repository/find_my_repository.dart';

class FindMyUseCase {
  final FindMyRepository _findMyRepository;

  FindMyUseCase({required FindMyRepository findMyRepositorr}) :_findMyRepository =findMyRepositorr;

  Future<User> call() => _findMyRepository.findMy(); 
}