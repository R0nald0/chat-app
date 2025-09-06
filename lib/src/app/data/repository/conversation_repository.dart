import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/data/datasource/chat_conversation_rest_client.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/repository/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository{
  final ChatConversationRestClient _chatConversationRestClient;

  ConversationRepositoryImpl({
    required ChatConversationRestClient chatConversationRestClient,
  }) : _chatConversationRestClient = chatConversationRestClient;

  @override
  Future<List<Conversation>> findAllByUser(int userId) async {
    try {
     final dtoList  = await _chatConversationRestClient.auth().findAll(userId);
      return dtoList.map<Conversation>((e) => Conversation(
        id: e.id,
        contactimageUrl: e.users.first.imageUrl,
        lastMassage: e.messages.last.content, 
        timeLastMessage: e.messages.first.createdAt, 
        contactName: e.users.first.name,
        idContact: e.id
        )
        ).toList();

    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
}
