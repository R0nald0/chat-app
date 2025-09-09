
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/repository/videos_shorts_repository.dart';

class FindShortVideos {
  final VideosShortsRepository _shortVideoRepository;

  FindShortVideos({required VideosShortsRepository shortVideoRepository}) :_shortVideoRepository =shortVideoRepository;

  Future<List<Video>> call() => _shortVideoRepository.finalAll();

}