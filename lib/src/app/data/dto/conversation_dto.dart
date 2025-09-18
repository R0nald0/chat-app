import 'dart:convert';

import 'package:chat/src/app/data/dto/message_dto.dart';

class ConversationDto {
  final int? id;
  final String subject;
  final String? lastMessage;
  final int? unreadMessages;
  final List<UserNameDto> users;
  final List<MessageDto> messages;

  ConversationDto({
    required this.id,
    required this.subject,
    required this.lastMessage,
    required this.unreadMessages,
    required this.users,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'lastMessage': lastMessage,
      'unreadMessages': unreadMessages,
      'users': users.map((x) => x.toMap()).toList(),
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory ConversationDto.fromMap(Map<String, dynamic> map) {
    return ConversationDto(
      id: map['id'] as int?,
      subject: map['subject'] as String? ?? '',
      lastMessage: map['lastMessage'] as String?,
      unreadMessages: map['unreadMessages'] as int?,
      users: (map['users'] as List<dynamic>? ?? [])
          .map((e) => UserNameDto.fromMap(e as Map<String, dynamic>))
          .toList(),
      messages: (map['messages'] as List<dynamic>? ?? [])
          .map((e) => MessageDto.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationDto.fromJson(String source) =>
      ConversationDto.fromMap(json.decode(source));
}

class UserNameDto {
  final String name;
  final int? id;
  final String? imageUrl;

  UserNameDto({required this.name, required this.id, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {'name': name, 'id': id, 'image_url': imageUrl};
  }

  factory UserNameDto.fromMap(Map<String, dynamic> map) {
    return UserNameDto(
      name: map['name'] as String? ?? '',
      id: map['id'] as int?,
      imageUrl: map['image_url'] as String?, // <- backend usa snake_case
    );
  }

  String toJson() => json.encode(toMap());

  factory UserNameDto.fromJson(String source) =>
      UserNameDto.fromMap(json.decode(source));
}

