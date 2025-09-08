import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/presentation/features/splashcreen/bloc/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenBloc extends Cubit<SplashScreenState> {
  final FindMyUseCase _findMyUseCase;
  SplashScreenBloc({required FindMyUseCase findMyUseCase})
    : _findMyUseCase = findMyUseCase,
      super(SplashScreenState.initial());

  Future<void> verifyUserOn() async {
    try {
      emit(state.copyWith(status: SplashScreenStatus.loading));
     await Future.delayed(Duration(seconds: 3));
      final user = await _findMyUseCase();
      emit(
        state.copyWith(status: SplashScreenStatus.success, user: () => user),
      );
    } on UserNotFound {
      emit(
        state.copyWith(
          status: SplashScreenStatus.erro,
          message: () => "Usuário nao ecncorado",
        ),
      );
    }
  }
}
