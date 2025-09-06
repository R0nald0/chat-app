import 'package:chat/src/app/domain/model/user.dart';

abstract interface class AuthRepository {
  
  Future<String> register( ({String email ,String name ,String password,String passwordConfirmation,String imageUrl}) data);
  Future<User> login(({String email, String password}) data);

}