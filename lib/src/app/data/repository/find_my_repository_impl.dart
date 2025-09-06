
import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/repository/find_my_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindMyRepositoryImpl  implements FindMyRepository{
  @override
  Future<User> findMy() async {
     final  pref = await SharedPreferences.getInstance();
    final user =   pref.getString(ChatConstants.PREF_KEY);
    if(user == null){
       throw UserNotFound();
    }
    return User.fromJson(user);
  }
  
}