import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/conversation.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final List<Conversation> conversations;
  final List<Conversation> recentsConversation;
  final String? message;

  HomeState.initial():this(conversations: [],recentsConversation: [],status: HomeStatus.initial);

  HomeState({
    required this.status,
    required this.conversations,
    required this.recentsConversation,
    this.message,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Conversation>? conversations,
    List<Conversation>? recentConversation,
    ValueGetter<String?>? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      recentsConversation: recentConversation ?? recentsConversation,
      message: message != null ? message() : this.message,
    );
  }
}
