
import 'package:chat/src/app/domain/repository/user_repository.dart';

class AddContact {
 final UserRepository _userRepository;
 AddContact({required UserRepository userRepository}) : _userRepository=userRepository;

 Future<int?> call(int contactId) => _userRepository.addContact(contactId);
}