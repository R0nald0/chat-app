import 'package:chat/src/app/domain/model/user.dart';

abstract interface class FindMyRepository {
  Future<User> findMy();
}
