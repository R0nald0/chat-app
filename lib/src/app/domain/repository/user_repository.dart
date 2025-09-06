import 'package:chat/src/app/domain/model/user.dart';

abstract interface class UserRepository {
   Future<User> findUserbyEmail(String emailToSearch) ;
}