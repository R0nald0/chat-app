
import 'package:chat/src/app/data/dto/story_dto.dart';

class Video {
   final String? id;
   final String descrition;
   final String urlVideo;
   final double duration;
   final  int   ownerId;
   final String ownerName;
   final String ownerUrlImge;
   final DateTime exparesAt;
   final DateTime createdAt;
  Video({
    this.id,
    required this.descrition,
    required this.urlVideo,
    required this.duration,
    required this.ownerId,
    required this.ownerName,
    required this.ownerUrlImge,
    required this.exparesAt,
    required this.createdAt,
  });
   
   factory  Video.fromVideoDto(String ownerName, String ownerUrlImge ,VideoDto dto){
     return Video(
      descrition: dto.description, 
      urlVideo: dto.urlVideo, 
      duration: dto.duration, 
      ownerId: dto.ownerId, 
      ownerName: ownerName, 
      ownerUrlImge: ownerUrlImge, 
      exparesAt: DateTime.now(), 
      createdAt: dto.createdAt,
      )  ; 
  }
}
