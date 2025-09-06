import 'package:flutter/material.dart';

extension Helper on BuildContext{
   void unFocos() =>FocusScope.of(this).unfocus(); 
}