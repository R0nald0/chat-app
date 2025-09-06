import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/videos.dart';

enum StoryStatus {
   loading,initial,error,success
}
class StoryState {
  final StoryStatus status;
  final List<Video> shortsVideos;
  final String? message;
  
  StoryState.initial():this(shortsVideos: [],status: StoryStatus.initial);
  
  StoryState({
    required this.status,
    required this.shortsVideos,
    this.message,
  });
  

  StoryState copyWith({
    StoryStatus? status,
    List<Video>? shortsVideos,
    ValueGetter<String?>? message,
  }) {
    return StoryState(
      status: status ?? this.status,
      shortsVideos: shortsVideos ?? this.shortsVideos,
      message: message != null ? message() : this.message,
    );
  }
}
