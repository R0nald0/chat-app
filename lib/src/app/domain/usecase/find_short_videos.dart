
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/repository/short_video_repository.dart';

class FindShortVideos {
  final ShortVideoRepository _shortVideoRepository;

  FindShortVideos({required ShortVideoRepository shortVideoRepository}) :_shortVideoRepository =shortVideoRepository;

  Future<List<Video>> call() => _shortVideoRepository.finalAll();

}