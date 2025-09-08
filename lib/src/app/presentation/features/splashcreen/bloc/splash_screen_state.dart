import 'package:flutter/widgets.dart';

import 'package:chat/src/app/domain/model/user.dart';

enum SplashScreenStatus { loading, initial, erro, success }

class SplashScreenState {
  final SplashScreenStatus status;
  final User? user;
  final String? message;

   SplashScreenState.initial():this(status: SplashScreenStatus.initial);

  SplashScreenState({required this.status, this.user, this.message});

  SplashScreenState copyWith({
    SplashScreenStatus? status,
    ValueGetter<User?>? user,
    ValueGetter<String?>? message,
  }) {
    return SplashScreenState(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      message: message != null ? message() : this.message,
    );
  }
}
