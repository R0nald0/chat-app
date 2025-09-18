import 'dart:async';
import 'dart:developer';

import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/data/dto/conversation_dto.dart';
import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_story_my_contacts.dart';
import 'package:chat/src/app/domain/usecase/update_read_conversation_use_case.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final ConversationUseCase _conversationUseCase;
  final FindStoryMyContacts _findStoryMyContacts;
  final ChatServiceSockte _chatServiceSockte;
  final UpdateReadConversationUseCase _updateReadConversationUseCase;
  final  FindMyUseCase _findMyUseCase;
   

   StreamSubscription<ConversationDto>? _convSub;

  HomeCubit({
    required FindMyUseCase findMyUseCase,
    required ConversationUseCase conversationUseCase,
    required FindStoryMyContacts findStoryMyContacts,
    required ChatServiceSockte chatServiceSockte,
    required UpdateReadConversationUseCase updateReadConersationMessasge

  }) : _conversationUseCase = conversationUseCase,
       _findStoryMyContacts = findStoryMyContacts,
       _chatServiceSockte = chatServiceSockte,
       _updateReadConversationUseCase = updateReadConersationMessasge,
       _findMyUseCase =findMyUseCase,
       super(HomeState.initial());
  


  Future<void> updateReadConversationMessages(int idConversation) async{
     try {
        emit(state.copyWith(status: HomeStatus.loading));
       final conversation =  await _updateReadConversationUseCase(idConversation);
       
         final index = state.conversations.indexWhere(
            (c) => c.id == conversation.id,
          );
          if (index != -1) {
            // já existe → atualiza posição
            final updatedList = List<Conversation>.from(state.conversations)
              ..removeAt(index)
              ..insert(0, conversation);

            emit(state.copyWith(status: HomeStatus.successConversation,conversations: updatedList,));
          }else {
            // não existe → adiciona direto no topo
            final updatedList = List<Conversation>.from(state.conversations)
              ..insert(0, conversation);

             emit(state.copyWith(status: HomeStatus.successConversation,conversations: updatedList,));
          } 

     } on RepositoryException catch (e) {
        emit(state.copyWith(status: HomeStatus.error,message:() => e.message,)); 
     }
  }
  Future<void> findAllByUser() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final conversations = await _conversationUseCase();
      final my  =await _findMyUseCase();
      await _chatServiceSockte.registetOn(my.id!);
      for (var conversation in conversations) {
        if (conversation.id != null) {
          _chatServiceSockte.joinConversation(conversation.id!);
        }
      }
      emit(
        state.copyWith(
          status: HomeStatus.successConversation,
          conversations: conversations,
          user: () => my,
        ),
      );
      await findStoryMyContacts();
      observerConversations();
    } on ServiceException catch (e) {
      emit(state.copyWith(status: HomeStatus.error, message: () => e.message));
    }
  }

  Future<void> findStoryMyContacts() async {
    try {
        final my = await _findMyUseCase();
     final myPefil = StoryDto(
        id: my.id ?? 0,
        imageUrl: my.urlImage ??'',
        name: 'Meu Perfil',
        storys: []
      ); 
      emit(state.copyWith(status: HomeStatus.loading));
      final story = await _findStoryMyContacts()..insert(0, myPefil);
      emit(
        state.copyWith(
          status: HomeStatus.successStorys,
          recentConversation: story,
        ),
      );
    } on RepositoryException catch (e) {
      emit(state.copyWith(message: () => e.message ?? 'Erro ao busacar dados'));
    }
  }

  Future<void> observerConversations() async {
    _convSub?.cancel();

   _convSub =   _chatServiceSockte.conversationontrollerSinck
        .listen((conversation) {
          final index = state.conversations.indexWhere(
            (c) => c.id == conversation.id,
          );

          if (index != -1) {
          
            final updatedList = List<Conversation>.from(state.conversations)
              ..removeAt(index)
              ..insert(0, Conversation.fromDto(conversation));

            emit(state.copyWith(conversations: updatedList));
          } else {
            // não existe → adiciona direto no topo
            final updatedList = List<Conversation>.from(state.conversations)
              ..insert(0, Conversation.fromDto(conversation));

            emit(state.copyWith(conversations: updatedList));
          }
        });
        
        _convSub?.onError((error) {
          log('erro ao buscar conversar', error: error, stackTrace: error);
          emit(state.copyWith(status: HomeStatus.error, message: () => error));
        });      
  }

  @override
  Future<void> close() {
    _convSub?.cancel();
    return super.close();
  }
  
}
