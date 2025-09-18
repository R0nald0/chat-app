import 'package:chat/src/app/domain/model/user.dart';

abstract interface class UserRepository {
   Future<User> findUserbyEmail(String emailToSearch) ;
   Future<List<User>> findMyContacts(int  id);
   Future<int?> addContact(int  contactId); 
}