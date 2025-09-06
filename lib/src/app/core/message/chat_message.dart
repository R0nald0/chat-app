import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

sealed class ChatMessage {
  static showError(String message,BuildContext context){
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: message));
  }

  static showSuccess(String message ,BuildContext context){
     showTopSnackBar(Overlay.of(context), CustomSnackBar.success(message: message));
  }

  static showInfo (String  message ,BuildContext context){
     showTopSnackBar(Overlay.of(context), CustomSnackBar.info(message: message));
  }
}