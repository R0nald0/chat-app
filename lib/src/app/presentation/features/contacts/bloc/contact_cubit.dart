import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/core/exceptions/user_not_found.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/usecase/add_contact.dart';
import 'package:chat/src/app/domain/usecase/find_by_email_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_conversation_by_contactId_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_contacts.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final FindByEmailUseCase _findByEmail;
  final FindMyContacts _findMyContacts;
  final AddContact _addContact;
  final FindConversationByContactIdUseCase _byContactIdUseCase;


  
  ContactCubit( {
     required FindConversationByContactIdUseCase byContactIdUseCase,
    required FindByEmailUseCase findByEmail,
    required FindMyContacts findMyContacts,
    required AddContact addContact,
  }) : _findByEmail = findByEmail,
       _findMyContacts = findMyContacts,
       _addContact = addContact,
       _byContactIdUseCase = byContactIdUseCase,
       super(ContactState.initial());
  
  Future<void> findConversationByContactId(User contact) async {
    try {
    
    emit(state.copyWith(status: ContactStatus.loading,conversationId: () => null,contact: () => null));
    log('Contact ${contact.name }');
    final convesation  =  await _byContactIdUseCase.call(contact.id!); 
   
    emit(state.copyWith(
      status: ContactStatus.findConversationUsers,
      contact: () => contact,
      conversationId: () => convesation,),);
    }on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ContactStatus.error,
          message: () => e.message,
        ),
      );
    }
  }
  Future<void> findUserByEmail(String email) async {
    try {
        state.copyWith(contact: null);
      if (email.isEmpty) {
        state.copyWith(
          status: ContactStatus.error,
          message: () => 'Insira um email válido',
        );
        emit(state.copyWith(status: ContactStatus.initial));
        return;
      }

       final c  = state.contacts.where((c) => c.email == email);
      if (c.isNotEmpty) {
          emit(state.copyWith(status: ContactStatus.error,message:() => 'Contato ja existe na lista'));
         return;
      }
      emit(state.copyWith(status: ContactStatus.loading));
      final user = await _findByEmail(email);

      emit(state.copyWith(status: ContactStatus.findUser, contact: () => user));
    } on RepositoryException catch (e) {
      emit(
        state.copyWith(
          status: ContactStatus.error,
          message: () => e.message ?? 'Erro ao buscar contatos',
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

  Future<void> findMyContacts() async {
    try {
      emit(state.copyWith(status: ContactStatus.loading));
      
      final contacts = await _findMyContacts();
      emit(state.copyWith(status: ContactStatus.success, contacts: contacts));
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

  Future<void> addContact(User contactId) async {
    try {
      log("contacts ${state.contacts.length}");
      emit(state.copyWith(status: ContactStatus.loading));
    
    
      final id = await _addContact.call(contactId.id!);
      findMyContacts();
    } on RepositoryException catch (e) {
       emit(
        state.copyWith(
          status: ContactStatus.error,
          message: () => e.message,
        ),
      );
    }
  }
}
