

import 'package:chat/src/app/data/dto/conversation_dto.dart';
import 'package:chat/src/app/domain/model/message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Conversation {
  final int? id;
  final int idContact;
  final Message lastMassage;
  final String? contactimageUrl;
  final String contactName;
  final int unreadMessages ;
  Conversation({
    this.id,
    this.contactimageUrl,
    required this.unreadMessages,
    required this.idContact,
    required this.lastMassage,
    required this.contactName,
  });


  factory Conversation.fromDto(ConversationDto dto){
    return Conversation(
        id: dto.id,
        contactimageUrl: dto.users.first.imageUrl,
        lastMassage: Message.fromDto(dto.messages.first) ,
         unreadMessages: dto.unreadMessages ?? 0,
        contactName: dto.users.first.name,
        idContact: dto.messages.first.senderId!
        );
  }
  Conversation copyWith({
    ValueGetter<int?>? id,
    int? idContact,
    Message? lastMassage,
    ValueGetter<String?>? contactimageUrl,
    DateTime? timeLastMessage,
    String? contactName,
    int? unreadMessages,
  }) {
    return Conversation(
      id: id != null ? id() : this.id,
      idContact: idContact ?? this.idContact,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      lastMassage: lastMassage ?? this.lastMassage,
      contactimageUrl: contactimageUrl != null ? contactimageUrl() : this.contactimageUrl,
      contactName: contactName ?? this.contactName,
    );
  }
}
