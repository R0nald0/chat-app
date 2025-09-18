import 'dart:async';
import 'dart:developer';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/data/dto/conversation_dto.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatServiceSockte {
  static final ChatServiceSockte _instance = ChatServiceSockte._i();

  late IO.Socket _socket;
  final FlutterSecureStorage _storage = getIt.get<FlutterSecureStorage>();
  final StreamController<Message> _messageControllerSick = StreamController<Message>.broadcast();
  final StreamController<ConversationDto> _conversationControllerSinck = StreamController<ConversationDto>.broadcast();

  Stream<Message> get messageControllerSick => _messageControllerSick.stream;
  Stream<ConversationDto> get conversationontrollerSinck => _conversationControllerSinck.stream;
  Stream<ConversationDto> get conversationControllerSinckRead => _conversationControllerSinck.stream;
  
  Future<void> dipose()  async{
   await  _messageControllerSick.close();
    await  _conversationControllerSinck.close();
  }
  ChatServiceSockte._i() {
    initSocket();
  }

  factory ChatServiceSockte() => _instance;

  Future<void> initSocket() async {
    final token = await _storage.read(key: ChatConstants.KEY_SECURITY);
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

     _socket.on('newMessage',(data) async{
          final message = Message.fromMap(data);
         _messageControllerSick.add(message);
     });

     _socket.on('updateMessage',(data) async{
         final my  = await getIt.get<FindMyUseCase>().call();
          final conversation = ConversationDto.fromMap(data['conversationUpadted']);
           conversation.users.removeWhere((u) => u.id == my.id);
            log('updateMessage');
         _conversationControllerSinck.add(conversation);
     });  
  }
  
  Future<void> readMessage(int conversationId ,int userId ) async{
    final data =    {
      'conversationId'  : conversationId,
      'userId' :userId
    };
     _socket.emit('readMessage',data);
  }
  
  Future<void> sendMessage(({ 
  int unReadMessage,
  String content,
  int conversationId,
  int senderId,
  int destinationId,
  String subject})message) async{
  
     final messageData =  {
         'unReadMessage' : message.unReadMessage,
         'conversationId' : message.conversationId,
         'content' :message.content,
         'senderId' : message.senderId,
         'destinationId' : message.destinationId,
         'subject' : message.subject
     };
     
     _socket.emit('sendMessage',messageData);

  }
  Future<void> joinConversation(int conversationId) async {
  _socket.emit('joinedConversation', conversationId);
  log('JOINED conversation $conversationId');
 }
 Future<void> registetOn(int idUser) async {
   _socket.emit('register',idUser);
 }
}
