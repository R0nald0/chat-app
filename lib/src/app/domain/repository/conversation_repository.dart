import 'package:chat/src/app/domain/model/conversation.dart';

abstract interface class ConversationRepository {
  Future<List<Conversation>> findAllByUser(int userId);
  Future<Conversation> updateReadConersationMessasge(int idConversation);
  Future<int?> findConversationByContactId(int idContact);

  Future<int?> create(
    ({int contactId, String subject, String message}) conversationData,
  );
}
