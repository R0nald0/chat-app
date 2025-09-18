
import 'package:chat/src/app/domain/repository/conversation_repository.dart';

class FindConversationByContactIdUseCase {
  final ConversationRepository _conversationRepository;

  FindConversationByContactIdUseCase({
    required ConversationRepository conversationRepository,
  }) : _conversationRepository = conversationRepository;

  Future<int?> call(int idContact) =>
      _conversationRepository.findConversationByContactId(idContact);
}
