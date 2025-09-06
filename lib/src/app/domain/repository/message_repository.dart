import 'package:chat/src/app/domain/model/message.dart';

abstract interface class MessageRepository {
  Future<List<Message>> findAll(int conversationId)  ;
  Future<void> sendMessage(({ String content,
  int conversationId,
  int senderId,
  int destiontionId,
  String subject})message);
   Stream<Message> receivedMessage();
}