import 'package:chat/src/app/data/dto/story_dto.dart';

class Video {
  final String? id;
  final String descrition;
  final String urlVideo;
  final double duration;
  final int ownerId;
  final String ownerName;
  final String ownerUrlImge;
  final DateTime exparesAt;
  final DateTime createdAt;
  final bool private;
  Video({
    this.id,
    required this.private,
    required this.descrition,
    required this.urlVideo,
    required this.duration,
    required this.ownerId,
    required this.ownerName,
    required this.ownerUrlImge,
    required this.exparesAt,
    required this.createdAt,
  });

  factory Video.fromVideoDto(
    String ownerName,
    String ownerUrlImge,
    VideoDto dto,
  ) {
    return Video(
      private: dto.private,
      descrition: dto.description,
      urlVideo: dto.urlVideo,
      duration: dto.duration,
      ownerId: dto.ownerId,
      ownerName: ownerName,
      ownerUrlImge: ownerUrlImge,
      exparesAt: dto.createdAt.add(Duration(days: 1)),
      createdAt: dto.createdAt,
    );
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        "id": final String id,
        "duration": final double duration,
        "url_video": final String urlVideo,
        "description": final String descrition,
        "private": final bool private,
        "ownerId": final int ownerId,
        "ownerName": final String ownerName,
        "ownerUrlImage": final String ownerUrlImge,
        "createdAt": final String createdAt,
      } =>
        Video(
          private: private,
          descrition: descrition,
          urlVideo: urlVideo,
          duration: duration,
          ownerId: ownerId,
          ownerName: ownerName,
          ownerUrlImge: ownerUrlImge,
          exparesAt: DateTime.parse(createdAt).add(Duration(days: 1)),
          createdAt: DateTime.parse(createdAt),
        ),
      _ => throw ArgumentError('Invalid Argument'),
    };
  }
}
