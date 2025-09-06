import 'package:chat/src/app/domain/model/conversation.dart';

abstract interface class ConversationRepository {
 Future<List<Conversation>> findAllByUser(int userId);
}