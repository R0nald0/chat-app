
import 'package:chat/src/app/domain/repository/message_repository.dart';

class SendMessageUseCase {
   final MessageRepository _messageRepository ;

   SendMessageUseCase({required MessageRepository messageRepository}) :_messageRepository= messageRepository;

   Future<void> call(({ 
  int unReadMessage,
  String content,
  int conversationId,
  int senderId,
  int destinationId,
  String subject})message) async{
       _messageRepository.sendMessage(message);
   } 
}