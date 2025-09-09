import 'package:bloc/bloc.dart';
import 'package:chat/src/app/core/exceptions/repository_exception.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/usecase/find_short_videos.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final FindShortVideos _findShortVideos;

  StoryCubit({required FindShortVideos findShortVIdeos})
    : _findShortVideos = findShortVIdeos,
      super(StoryState.initial());

  Future<void> finalAllShortsVideos(List<Video>? videos) async {
    try {
      emit(state.copyWith(status: StoryStatus.loading));
      if (videos == null) {
        final videos = await _findShortVideos();
        emit(state.copyWith(status: StoryStatus.success, shortsVideos: videos));
        return;
      }

      emit(state.copyWith(status: StoryStatus.success, shortsVideos: videos));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: StoryStatus.error, message: () => e.message));
    }
  }

}
