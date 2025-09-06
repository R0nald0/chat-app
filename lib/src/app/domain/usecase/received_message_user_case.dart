
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/repository/message_repository.dart';

class ReceivedMessageUserCase {
 final MessageRepository _messageRepository ;
 ReceivedMessageUserCase({required MessageRepository messageRepository}) : _messageRepository= messageRepository;

 Stream<Message> receivedMessage() => _messageRepository.receivedMessage();
}