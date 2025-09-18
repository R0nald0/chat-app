
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/repository/videos_shorts_repository.dart';


class CreateVideoUseCase {
  final VideosShortsRepository _videosShortsRepository;
  CreateVideoUseCase({required VideosShortsRepository videoRepository}): _videosShortsRepository = videoRepository;
    Future<Video> call(({
      String owneriId,
      String description,
      double duration,
      bool privateVideo,
      String urlVideo,
    })
    dataVideo,) =>  _videosShortsRepository.create(dataVideo);
}