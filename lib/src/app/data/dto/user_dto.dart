import 'dart:convert';

class UserDto {
  final String email; 
  final String name;
  final int id;
  final String? imageUrl; 
  UserDto( {required this.email, required this.imageUrl, required this.name, required this.id});

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'id': id,?imageUrl : 'image_url'};
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'email': final String email,
        'name': final String name,
        'id': final int id,
        'image_url': final String? imageUrl
      } =>
        UserDto(
          imageUrl: imageUrl ?? "",
          email:email,
          name:name,
          id: id,
        ),
      _ => throw ArgumentError('Invalid json'),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserDto.fromJson(String source) =>
      UserDto.fromMap(json.decode(source));
}
