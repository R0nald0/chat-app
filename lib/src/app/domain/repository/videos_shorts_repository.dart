import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/videos.dart';

abstract interface class VideosShortsRepository {
  
 Future<List<Video>> finalAll();
 Future<List<StoryDto>> findStoryMyContacts(int id);

 Future<Video> create(
    ({
      String owneriId,
      String description,
      double duration,
      bool privateVideo,
      String urlVideo,
    })
    dataVideo,
  );
}