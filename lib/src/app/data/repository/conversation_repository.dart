import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/data/datasource/chat_conversation_rest_client.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ChatConversationRestClient _chatConversationRestClient;

  ConversationRepositoryImpl({
    required ChatConversationRestClient chatConversationRestClient,
  }) : _chatConversationRestClient = chatConversationRestClient;

  @override
  Future<int?> findConversationByContactId(int idContact) async {
    try {
      return await _chatConversationRestClient.auth().findConversationByContactId(
        idContact,
      );
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<int?> create(
    ({int contactId, String subject, String message}) conversationData,
  ) async {
    try {
      return await _chatConversationRestClient.createConversation(conversationData);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<List<Conversation>> findAllByUser(int userId) async {
    try {
      final dtoList = await _chatConversationRestClient.auth().findAll(userId);
      return dtoList
          .map<Conversation>(
            (e) => Conversation(
              id: e.id,
              contactimageUrl: e.users.first.imageUrl,
              lastMassage: Message.fromDto(e.messages.first),
              unreadMessages: e.unreadMessages ?? 0,
              contactName: e.users.first.name,
              idContact: e.users.first.id!,
            ),
          )
          .toList();
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<Conversation> updateReadConersationMessasge(int idConversation) async {
    try {
      final dto = await _chatConversationRestClient
          .updateReadConersationMessasge(idConversation);
      return Conversation.fromDto(dto);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
}
