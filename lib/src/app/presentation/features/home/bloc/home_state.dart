import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/conversation.dart';

enum HomeStatus { initial, loading, successConversation ,successStorys , error }

class HomeState {
  final HomeStatus status;
  final List<Conversation> conversations;
  final List<StoryDto> story;
  final String? message;

  HomeState.initial():this(conversations: [],story: [],status: HomeStatus.initial);

  HomeState({
    required this.status,
    required this.conversations,
    required this.story,
    this.message,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Conversation>? conversations,
    List<StoryDto>? recentConversation,
    ValueGetter<String?>? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      story: recentConversation ?? story,
      message: message != null ? message() : this.message,
    );
  }
}
