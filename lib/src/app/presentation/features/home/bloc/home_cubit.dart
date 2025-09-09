import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_story_my_contacts.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final ConversationUseCase _conversationUseCase;
  final FindStoryMyContacts _findStoryMyContacts;

  HomeCubit({
    required ConversationUseCase conversationUseCase,
    required FindStoryMyContacts findStoryMyContacts,
  }) : _conversationUseCase = conversationUseCase,
       _findStoryMyContacts = findStoryMyContacts,
       super(HomeState.initial());

  Future<void> findAllByUser() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final conversations = await _conversationUseCase();
      emit(
        state.copyWith(
          status: HomeStatus.successConversation,
          conversations: conversations,
        ),
      );
    } on ServiceException catch (e) {
      emit(state.copyWith(status: HomeStatus.error, message: () => e.message));
    }
  }

  Future<void> findStoryMyContacts() async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final story = await _findStoryMyContacts();
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
}
