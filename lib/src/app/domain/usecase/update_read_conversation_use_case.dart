
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/repository/conversation_repository.dart';

class UpdateReadConversationUseCase {
  final ConversationRepository _conversationRepository;

  UpdateReadConversationUseCase({required ConversationRepository conversationRepository}) :_conversationRepository =conversationRepository;
  Future<Conversation> call(int idConversation) => _conversationRepository.updateReadConersationMessasge(idConversation);
}