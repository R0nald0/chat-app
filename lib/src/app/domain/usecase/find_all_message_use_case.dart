
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/repository/message_repository.dart';

class FindAllMessageUseCase {
   final MessageRepository _messageRepository;

   FindAllMessageUseCase({required MessageRepository messageRepository}) :_messageRepository =messageRepository;

  Future<List<Message>> call(int conversationId) => _messageRepository.findAll(conversationId);
}