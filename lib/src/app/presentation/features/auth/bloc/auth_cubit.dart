import 'package:chat/src/app/domain/usecase/login_use_case.dart';
import 'package:chat/src/app/domain/usecase/lout_use_case.dart';
import 'package:chat/src/app/domain/usecase/register_use_case.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/exceptions/repository_exception.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registrtUseCase,
    required LogoutUseCase logoutUseCse
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registrtUseCase,
       _logoutUseCase =logoutUseCse,
       super(AuthState.initial());

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final data = (email: email, password: password);
      final user = await _loginUseCase(data);
      emit(state.copyWith(status: AuthStatus.success, user: () => user));
      
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          message: () => e.message,
          status: AuthStatus.error,
        ),
      );
    }
  }

  Future<void> register(
    String email,
    String password,
    String name,
    String confirmPassword,
    String imageUrl
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final data = (
        email: email,
        name: name,
        password: password,
        passwordConfirmation: confirmPassword,
        imageUrl : imageUrl
      );

      final result = await _registerUseCase(data);
      emit(state.copyWith(status: AuthStatus.success, message: () => result));
    }on RepositoryException catch (e) {
      emit(
        state.copyWith(
          message: () => e.message,
          status: AuthStatus.error,
        ),
      );
    }
  }

  Future<void> logout()async {
    try {
       emit(state.copyWith(status: AuthStatus.loading));
      final nullUser = await _logoutUseCase();
      emit(state.copyWith(status: AuthStatus.success,user: null));
    }on RepositoryException catch (e) {
       emit(state.copyWith(status: AuthStatus.error,message:() => e.message ?? 'Erro ao deslogar usuário'));
    }
  }
}
