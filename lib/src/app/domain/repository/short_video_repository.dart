import 'package:chat/src/app/domain/model/videos.dart';

abstract interface class ShortVideoRepository {
  
 Future<List<Video>> finalAll();
}