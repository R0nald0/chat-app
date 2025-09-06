import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/user.dart';

enum AuthStatus{
  loading,error,success,initial
}
class AuthState {
   final AuthStatus status;
   final User? user;
   final String? message;
  AuthState({
    required this.status,
    this.user,
    this.message,
  }); 
  AuthState.initial() : this(status: AuthStatus.initial);
 
  AuthState copyWith({
    AuthStatus? status,
    ValueGetter<User?>? user,
    ValueGetter<String?>? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      message: message != null ? message() : this.message,
    );
  }
}
