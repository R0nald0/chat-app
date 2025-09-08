class VideoDto {
  final String id;
  final String urlVideo;
  final double duration;
  final String description;
  final int ownerId;
  final DateTime createdAt;

  VideoDto({
    required this.id,
    required this.urlVideo,
    required this.duration,
    required this.description,
    required this.ownerId,
    required this.createdAt,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) {
    return VideoDto(
      id: json['id'],
      urlVideo: json['url_video'],
      duration: (json['duration'] as num).toDouble(),
      description: json['description'],
      ownerId: json['ownerId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url_video': urlVideo,
      'duration': duration,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserDto {
  final int id;
  final String imageUrl;
  final String name;
  final List<VideoDto> videos;

  UserDto({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.videos,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      imageUrl: json['image_url'],
      name: json['name'],
      videos: (json['videos'] as List)
          .map((v) => VideoDto.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': name,
      'videos': videos.map((v) => v.toJson()).toList(),
    };
  }
}
