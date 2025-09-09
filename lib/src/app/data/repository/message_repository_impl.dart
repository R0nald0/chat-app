import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/data/datasource/chat_message_rest_client.dart';
import 'package:chat/src/app/data/dto/user_dto.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/repository/message_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ChatMessageDataSouce _chatMessageDataSouce;
  final ChatServiceSockte _chatServiceSockte = ChatServiceSockte();

  MessageRepositoryImpl({
    required ChatMessageDataSouce chatMessageDataSouce,
  }) : _chatMessageDataSouce = chatMessageDataSouce;

  @override
  Future<List<Message>> findAll(int conversationId) async {
    try {
      return await _chatMessageDataSouce.auth().findAll(conversationId);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<void> sendMessage(({ String content,
  int conversationId,
  int senderId,
  int destiontionId,
  String subject})message) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final user = pref.getString(ChatConstants.PREF_KEY);
      
      if (user == null) {
        throw RepositoryException(message: 'Erro ao buscar dados do usuário');
      }
      final UserDto(:id) = UserDto.fromJson(user);
      _chatServiceSockte.sendMessage(message);
    } on RepositoryException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
  @override
  Stream<Message> receivedMessage() async*{
    yield* _chatServiceSockte.messageControllerSick;
  }
}
