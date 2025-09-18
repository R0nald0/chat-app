import 'dart:convert';

class StoryDto {
  final int id;
  final String imageUrl;
  final String name;
  final List<VideoDto> storys;
  StoryDto({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.storys,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_url': imageUrl,
      'name': name,
      'videos': storys.map((x) => x.toMap()).toList(),
    };
  }

  factory StoryDto.fromMap(Map<String, dynamic> map) {
    return switch(map) {{
       'id':final int id,
      'image_url':final String imageUrl,
      'name': final String name,
      'videos': final List<dynamic> mapVideo ,
      } =>
       StoryDto(
        id: id, 
        imageUrl: imageUrl, 
        name: name, 
        storys:  mapVideo.map<VideoDto>((m) =>  VideoDto.fromMap(m)).toList(),
        ),
        _ => throw ArgumentError('Invalid Json')
    };
  }

  String toJson() => json.encode(toMap());
  factory StoryDto.fromJson(String source) =>
      StoryDto.fromMap(json.decode(source));
}

class VideoDto {
  final String id;
  final String urlVideo;
  final double duration;
  final String description;
  final int ownerId;
  final DateTime createdAt;
  final bool private ;

  VideoDto({
    required this.id,
    required this.urlVideo,
    required this.duration,
    required this.description,
    required this.ownerId,
    required this.createdAt,
    required this.private
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url_video': urlVideo,
      'duration': duration,
      'description': description,
      'ownerId': ownerId,
      'private' : private,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory VideoDto.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
      'id':final String id,
      'url_video':final String urlVideo,
      'duration': final double duration,
      'description': final String description,
      'ownerId': final int ownerId,
      'createdAt':final String date,
      'private' : final bool private
    }
       =>VideoDto(
      id: id,
      urlVideo: urlVideo,
      duration: duration,
      description: description,
      ownerId: ownerId,
      private: private,
      createdAt: DateTime.parse(date),
    ),
      _=> throw ArgumentError('Invalid json')
    };
  }
  String toJson() => json.encode(toMap());

  factory VideoDto.fromJson(String source) =>
      VideoDto.fromMap(json.decode(source));
}
