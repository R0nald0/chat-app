class ConversationDto {
  final int id;
  final String subject;
  final List<UserNameDto> users;
  final List<MessageDto> messages;

  ConversationDto({
    required this.id,
    required this.subject,
    required this.users,
    required this.messages,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
      id: json['id'],
      subject: json['subject'] ?? '',
      users: (json['users'] as List<dynamic>)
          .map((u) => UserNameDto.fromJson(u))
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((m) => MessageDto.fromJson(m))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'users': users.map((u) => u.toJson()).toList(),
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}

class UserNameDto {
  final String name;
  final int id;
  final String? imageUrl;

  UserNameDto({required this.name,required this.id,required this.imageUrl});

  factory UserNameDto.fromJson(Map<String, dynamic> json) {
    return UserNameDto(
      imageUrl: json['image_url'],
      name: json['name'],
      id: json['id'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url' : imageUrl,
      'id' :id
    };
  }
}

class MessageDto {
  final String content;
  final int senderId;
  final DateTime createdAt;

  MessageDto({
    required this.content,
    required this.senderId,
    required this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      content: json['content'],
      senderId: json['senderId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
