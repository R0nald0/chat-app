import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/conversation.dart';

enum HomeStatus { initial, loading, successConversation ,successStorys , error,readMessages }

class HomeState {
  final HomeStatus status;
  final List<Conversation> conversations;
  final List<StoryDto> story;
  final String? message;
  final User? user;

  HomeState.initial():this(conversations: [],story: [],status: HomeStatus.initial,user: null);

  HomeState({
    required this.status,
    required this.conversations,
    required this.story,
    required this.user,
    this.message,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Conversation>? conversations,
    List<StoryDto>? recentConversation,
    ValueGetter<String?>? message,
    ValueGetter<User?>? user
  }) {
    return HomeState(
      user: user !=  null  ? user() : this.user,
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      story: recentConversation ?? story,
      message: message != null ? message() : this.message,
    );
  }
}
