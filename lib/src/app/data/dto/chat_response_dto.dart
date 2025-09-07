import 'dart:convert';

import 'package:chat/src/app/data/dto/user_dto.dart';


class ChatResponseDto {
  final UserDto user;
  final String token;
  ChatResponseDto({required this.user, required this.token});

  Map<String, dynamic> toMap() {
    return {'user': user.toMap(), 'token': token};
  }

  factory ChatResponseDto.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'user': final Map<String,dynamic> user, 'token': final String token} => ChatResponseDto(
        user: UserDto.fromMap(user),
        token: token,
      ),
      _=> throw ArgumentError('Invalid json')
    };
  }

  String toJson() => json.encode(toMap());

  factory ChatResponseDto.fromJson(String source) =>
      ChatResponseDto.fromMap(json.decode(source));
}
