import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatLoader extends StatelessWidget {
  final double size;

  const ChatLoader({ super.key ,this.size = 40 });

   @override
   Widget build(BuildContext context) {
       return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size:size),
       );
  }
}