
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/user.dart';

enum ContactStatus {
  loading,initial ,error,success,findUser
}
class ContactState {
  final ContactStatus status;
  final User? contact;
  final String? message;
  final List<User> contacts;
  
  ContactState.initial() :this(contacts: [],status: ContactStatus.initial,);
  
  ContactState({
    required this.status,
    this.contact,
    this.message,
    required this.contacts,
  });
  

  ContactState copyWith({
    ContactStatus? status,
    ValueGetter<User?>? contact,
    ValueGetter<String?>? message,
    List<User>? contacts,
  }) {
    return ContactState(
      status: status ?? this.status,
      contact: contact != null ? contact() : this.contact,
      message: message != null ? message() : this.message,
      contacts: contacts ?? this.contacts,
    );
  }
}
