
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit  extends Cubit<HomeState>{
  final ConversationUseCase _conversationUseCase;

  HomeCubit({required ConversationUseCase conversationUseCase}): 
  _conversationUseCase = conversationUseCase , super(HomeState.initial()) ;
  

  Future<void> findAllByUser()async{
       try {
         emit(state.copyWith(status: HomeStatus.loading));
         final conversations  =  await _conversationUseCase();
         emit(state.copyWith(status: HomeStatus.success,conversations: conversations));
       }on ServiceException catch (e) {
         emit(state.copyWith(status: HomeStatus.error,message: () => e.message,));
       }
  }
}