import 'dart:async';
import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatServiceSockte {
  static final ChatServiceSockte _instance = ChatServiceSockte._i();

  late IO.Socket _socket;
  final FlutterSecureStorage _storage = getIt.get<FlutterSecureStorage>();
  final StreamController<Message> _messageControllerSick = StreamController<Message>.broadcast();
   
  Stream<Message> get messageControllerSick => _messageControllerSick.stream;
  ChatServiceSockte._i() {
    initSocket();
  }
  factory ChatServiceSockte() => _instance;

  Future<void> initSocket() async {
    final token = _storage.read(key: ChatConstants.KEY_SECURITY);
    _socket = IO.io(
      ChatConstants.BASE_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'authorization': 'Bearer $token'})
          .build(),
    );
     
    _socket.connect();
    _socket.onConnect((_){
      print('SOCKET ID ${_socket.id}');
    });

    _socket.onDisconnect((_){
      print('SOCKET DISCONNECTED ${_socket.id}');
         
    });

    _socket.onError((err) {
      log('SOCKET ERROR: $err');
    });

     _socket.on('newMessage',(data){
           final message = Message.fromMap(data);
         _messageControllerSick.add(message);
     });
  }
  
  Future<void> sendMessage(({ String content,
  int conversationId,
  int senderId,
  int destiontionId,
  String subject})message) async{
  
     final messageData =  {
         'conversationId' : message.conversationId,
         'content' :message.content,
         'senderId' : message.senderId,
         'destinationId' : message.destiontionId,
         'subject' : message.subject
     };
      joinConversation(message.conversationId);
     _socket.emit('sendMessage',messageData);

  }
  void joinConversation(int conversationId) {
  _socket.emit('joinedConversation', conversationId);
  log('JOINED conversation $conversationId');
}
}
