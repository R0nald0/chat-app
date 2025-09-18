import 'dart:convert';

class MessageDto {
  final String content;
  final int? senderId;
  final DateTime createdAt;

  MessageDto({
    required this.content,
    required this.senderId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MessageDto.fromMap(Map<String, dynamic> map) {
    return MessageDto(
      content: map['content'] as String? ?? '',
      senderId: map['senderId'] as int?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageDto.fromJson(String source) =>
      MessageDto.fromMap(json.decode(source));
}
