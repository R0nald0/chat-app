
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/user.dart';

enum ContactStatus {
  loading,initial ,error,success,findUser,findConversationUsers
}
class ContactState {
  final ContactStatus status;
  final User? contact;
  final int? conversationId;
  final String? message;
  final List<User> contacts;
  
  ContactState.initial() :this(contacts: [],status: ContactStatus.initial,);
  
  ContactState({
    required this.status,
    this.contact,
    this.conversationId,
    this.message,
    required this.contacts,
  });
  

  ContactState copyWith({
    ContactStatus? status,
    ValueGetter<User?>? contact,
    ValueGetter<String?>? message,
    List<User>? contacts,
    ValueGetter<int?>?  conversationId
  }) {
    return ContactState(
      status: status ?? this.status,
      contact: contact != null ? contact() : this.contact,
      conversationId: conversationId != null ? conversationId() : this.conversationId,
      message: message != null ? message() : this.message,
      contacts: contacts ?? this.contacts,
    );
  }
}
