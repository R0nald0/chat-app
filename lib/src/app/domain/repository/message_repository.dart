import 'package:chat/src/app/domain/model/message.dart';

abstract interface class MessageRepository {
  Future<List<Message>> findAll(int conversationId)  ;
  Future<void> sendMessage(({ 
  int unReadMessage,
  String content,
  int conversationId,
  int senderId,
  int destinationId,
  String subject})message);
   Stream<Message> receivedMessage();
}