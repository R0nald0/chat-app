import 'dart:developer';

import 'package:chat/src/app/core/exceptions/data_source_exception.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/data/datasource/chat_message_rest_client.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ChatMessageDataSouce _chatMessageDataSouce;
  final ChatServiceSockte _chatServiceSockte;

  MessageRepositoryImpl({
    required ChatMessageDataSouce chatMessageDataSouce,
    required ChatServiceSockte chatServiceSockte,
  }) : _chatMessageDataSouce = chatMessageDataSouce,_chatServiceSockte =chatServiceSockte;

  @override
  Future<List<Message>> findAll(int conversationId) async {
    try {
      return await _chatMessageDataSouce.auth().findAll(conversationId);
    } on DataSourceException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }

  @override
  Future<void> sendMessage(({ 
  int unReadMessage  ,
  String content,
  int conversationId,
  int senderId,
  int destinationId,
  String subject})message) async {
    try {
      log('Message repo ${message.toString()}');
     await _chatServiceSockte.sendMessage(message);
    } on RepositoryException catch (e) {
      throw RepositoryException(message: e.message);
    }
  }
  @override
  Stream<Message> receivedMessage() async*{
    yield* _chatServiceSockte.messageControllerSick;
  }
}
