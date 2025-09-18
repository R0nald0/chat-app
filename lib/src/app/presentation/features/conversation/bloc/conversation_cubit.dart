import 'dart:async';
import 'dart:developer';

import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/usecase/create_conversation_use_case.dart';
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
  final ChatServiceSockte _chatServiceSockte;
  final CreateConversationUseCase _createConversationUseCase;
  ConversationCubit({
    required FindAllMessageUseCase findAllMessageUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required ReceivedMessageUserCase receivedMessageUseCase,
    required FindMyUseCase findMyUseCase,
    required ChatServiceSockte chatServiceSockte,
    required CreateConversationUseCase createConversationUseCase,
  }) : _findAllMessage = findAllMessageUseCase,
       _receivedMessageUserCase = receivedMessageUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _findMyUseCase = findMyUseCase,
       _chatServiceSockte = chatServiceSockte,
       _createConversationUseCase = createConversationUseCase,
       super(ConversationState.initial());

  StreamSubscription<Message>? _subscription;

  Future<void> findAllMessages(int? conversationId) async {
    try {
      _listenReceivedMessages();
      emit(state.copyWith(status: ConversationStatus.loading));
      final user = await _findMyUseCase();
      if (conversationId == null || conversationId == 0) {
        emit(
        state.copyWith(
          status: ConversationStatus.success,
          my: () => user,
        ),
      );
        return;
      }
      final messages = await _findAllMessage(conversationId);
  
      emit(
        state.copyWith(
          status: ConversationStatus.success,
          my: () => user,
          messages: messages,
          idConversation: () => conversationId,
        ),
      );

      
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ConversationStatus.error,
          message: () => e.message,
        ),
      );
    } on UserNotFound {
      emit(
        state.copyWith(
          status: ConversationStatus.error,
          message: () => 'Usuário não encontrado',
        ),
      );
    }
  }

  void _listenReceivedMessages() async {
    await _subscription?.cancel();

    _subscription = _chatServiceSockte.messageControllerSick.listen((data) {
      log('CHEGOU }');
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ConversationStatus.success,
            messages: [...state.messages, data],
          ),
        );
      }

      log('received message ${data.toJson()}');
    });
  }

  Future<void> sendMessage(String content, Conversation conversation) async {
    try {
       var idConversation = state.idConversation;
      if ( idConversation == 0 || idConversation == null) {
          final conversationData = (
            contactId : conversation.idContact, 
            subject : '',
            message : content
          );
          idConversation = await _createConversationUseCase(conversationData);
          
          log('Criando conversa $idConversation }');
        
      }
       emit(state.copyWith(status: ConversationStatus.loading));
     final User(:id) = await _findMyUseCase();
      final message = (
        unReadMessage: 0,
        content: content,
        conversationId: idConversation ?? 0,
        senderId: id!,
        destinationId: conversation.idContact,
        subject: '',
      );

      await _sendMessageUseCase(message);
      _chatServiceSockte.joinConversation(idConversation!);
      emit(state.copyWith(status: ConversationStatus.success,idConversation:() => idConversation));
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ConversationStatus.error,
          message: () => e.message ?? 'Erro ao enviar mensagem',
        ),
      );
    }
  }

  @override
  Future<void> close()async {
  await  _subscription?.cancel();
 // await  _chatServiceSockte.dipose();
    return super.close();
  }
}
