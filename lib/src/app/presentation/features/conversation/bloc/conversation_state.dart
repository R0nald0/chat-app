import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/message.dart';
import 'package:chat/src/app/domain/model/user.dart';

enum ConversationStatus { loading, error, initial, success }

class ConversationState {
  final ConversationStatus status;
  final int? idConversation;
  final List<Message> messages;
  final String? message;
  final Message? receivedMessge;
  final User? my;
  final List<User> participants;

  ConversationState({
    required this.status,
    required this.messages,
    this.message,
    this.receivedMessge,
    this.my,
    this.idConversation,
    required this.participants,
  });
  
  ConversationState.initial()
    : this(messages: [], status: ConversationStatus.initial,participants: []);
   

  ConversationState copyWith({
    ConversationStatus? status,
    List<Message>? messages,
    ValueGetter<String?>? message,
    ValueGetter<Message?>? receivedMessge,
    ValueGetter<User?>? my,
    ValueGetter<int?>? idConversation,
    List<User>? participants,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      idConversation: idConversation != null ? idConversation() : this.idConversation,
      message: message != null ? message() : this.message,
      receivedMessge: receivedMessge != null ? receivedMessge() : this.receivedMessge,
      my: my != null ? my() : this.my,
      participants: participants ?? this.participants,
    );
  }
}
