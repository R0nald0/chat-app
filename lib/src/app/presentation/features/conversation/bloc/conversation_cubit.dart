import 'dart:developer';

import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/usecase/find_all_message_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/domain/usecase/received_message_user_case.dart';
import 'package:chat/src/app/domain/usecase/send_message_use_case.dart';
import 'package:chat/src/app/presentation/features/conversation/bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {

   
  final FindAllMessageUseCase _findAllMessage;
  final SendMessageUseCase _sendMessageUseCase;
  final ReceivedMessageUserCase _receivedMessageUserCase;
  final FindMyUseCase _findMyUseCase;

  ConversationCubit({
    required FindAllMessageUseCase findAllMessageUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required ReceivedMessageUserCase receivedMessageUseCase,
    required FindMyUseCase findMyUseCase,
  }) : _findAllMessage = findAllMessageUseCase,
       _receivedMessageUserCase = receivedMessageUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _findMyUseCase = findMyUseCase,

       super(ConversationState.initial());
    final minhasMsgs = <Message>[];
  Future<void> findAllMessages(int? conversationId) async {
    try {
      if (conversationId == null) {
         return;
      }
      emit(state.copyWith(status: ConversationStatus.loading));
      final messages = await _findAllMessage(conversationId);
      final user = await _findMyUseCase();

      emit(
        state.copyWith(status: ConversationStatus.success,my: () => user ,messages: messages),
      );
      _receivedMessageUserCase.receivedMessage().listen((data){
        
        emit(state.copyWith(status: ConversationStatus.loading));
        messages.addAll([data]);
   
        emit(
        state.copyWith(status: ConversationStatus.success,my: () => user ,messages: messages),
      );
        log('received message $data');
      });
    }on RepositoryException catch (e) {
      emit(
        state.copyWith(status: ConversationStatus.error,message: () => e.message),
      );
    } on UserNotFound {
        emit(
        state.copyWith(status: ConversationStatus.error,message: () => 'Usuário não encontrado'),
      );
    }
  }

  Future<void> sendMessage(String content, Conversation conversation ) async {
    try {
        
        
       final User( :id) = await _findMyUseCase();
       final  message =   ( 
        content : content,
        conversationId : conversation.id ?? 0,
        senderId : id!,
        destiontionId : conversation.idContact ,
        subject : '');
     
      emit(state.copyWith(status: ConversationStatus.loading));
      
      await _sendMessageUseCase(message);

      emit(state.copyWith(status: ConversationStatus.success));
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ConversationStatus.error,
          message: () => e.message ?? 'Erro ao enviar mensagem',
        ),
      );
    }
  }
}
