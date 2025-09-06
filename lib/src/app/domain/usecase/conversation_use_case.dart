import 'dart:developer';

import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/repository/conversation_repository.dart';
import 'package:chat/src/app/domain/model/user.dart';

class ConversationUseCase {
  final ConversationRepository _conversationRepository;
  ConversationUseCase({required ConversationRepository conversationRepository})
    : _conversationRepository = conversationRepository;

  Future<List<Conversation>> call() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(ChatConstants.PREF_KEY);
      if (json == null) {
        throw ServiceException(message: 'Falha ao buscar dados do usuário');
      }
      final user = User.fromJson(json);
      log("User ${ user.toJson()}");
      if (user.id == null) {
        throw ServiceException(message: 'Falha ao buscar dados do usuário');
      }

      return _conversationRepository.findAllByUser(user.id!);
    } on ServiceException catch (e, s) {
      log('Erro ao buscar dados do usuário', error: e, stackTrace: s);
      throw ServiceException(message: e.message);
    } on RepositoryException catch (e, s) {
      final errorMessage = e.message ?? 'Erro desconhecido';
      log(errorMessage, error: e, stackTrace: s);
      throw ServiceException(message: e.message ?? errorMessage);
    }
  }
}

class ServiceException implements Exception {
  final String message;
  ServiceException({required this.message});
}
