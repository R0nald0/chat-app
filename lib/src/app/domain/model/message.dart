import 'dart:convert';

import 'package:chat/src/app/core/extension/data_extension.dart';

class Message {
  final int? id;
  final int senderId;
  final int conversationId;
  final String content;
  final String createdAt;
  Message({
    required this.id,
    required this.senderId,
    required this.conversationId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'conversationId': conversationId,
      'content': content,
      'createdAt': createdAt,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return switch(map){ {
      'id': final  int id,
      'senderId': final int senderId,
      'conversationId':final int conversationId,
      'content': final String content,
      'createdAt':final String createdAt,
    }
       =>  Message(
      id: id,
      senderId: senderId,
      conversationId: conversationId,
      content : content,
      createdAt:  DateTime.parse(createdAt).formatedToStringDayMinute(),
    ),
    _=> throw ArgumentError('Invalid json')

    } ;
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
