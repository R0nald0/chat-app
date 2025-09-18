
import 'package:chat/src/app/domain/repository/conversation_repository.dart';

class CreateConversationUseCase {
  final ConversationRepository _conversationRepository;
    CreateConversationUseCase({required ConversationRepository conversationRepository}) : _conversationRepository = conversationRepository;
    Future<int?>
    call(({int contactId, String subject, String message}) conversationData) => _conversationRepository.create(conversationData);


  
}