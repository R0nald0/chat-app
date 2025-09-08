import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:flutter/material.dart';

sealed class ChatAppTheme {
  static const _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  /// Tema claro
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.grey),
      border: _defaultInputBorder,
      enabledBorder: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      errorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),
  );

  /// Tema escuro
  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      labelStyle: const TextStyle(color: Colors.white70),
      border: _defaultInputBorder,
      errorMaxLines: 1,
      errorStyle: TextStyle(
        color: Colors.red
      ),
      enabledBorder: _defaultInputBorder.copyWith(
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.orange),
      ),
      errorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),

     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        backgroundColor: ColorsConstantes.brow
      )
    ),
  );
}
