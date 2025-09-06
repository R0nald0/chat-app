import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/usecase/find_by_email_use_case.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final FindByEmailUseCase _findByEmail;

  ContactCubit({required FindByEmailUseCase findByEmail})
    : _findByEmail = findByEmail,
      super(ContactState.initial());

  Future<void> findUserByEmail(String email) async {
    try {
      emit(state.copyWith(status: ContactStatus.loading));
      final user = await _findByEmail(email);
      emit(state.copyWith(status: ContactStatus.success, contact: () => user));
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ContactStatus.error,
          message: () => e.message ?? 'Erro ao buscar contato',
        ),
      );
   
    } on UserNotFound {
      emit(
        state.copyWith(
          status: ContactStatus.error,
          message: () => 'Erro ao buscar contato',
        ),
      );
      
    }
  }
}
