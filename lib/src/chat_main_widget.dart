import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/presentation/features/auth/login_page.dart';
import 'package:chat/src/app/presentation/features/auth/register_page.dart';
import 'package:chat/src/app/presentation/features/conversation/conversation_page.dart';
import 'package:chat/src/app/presentation/main_navigation.dart';
import 'package:flutter/material.dart';

class ChatMainWidget extends StatelessWidget {

  const ChatMainWidget({ super.key });

   @override
   Widget build(BuildContext context) {
       return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login' : (context) => LoginPage(),
        '/register' : (context) => RegisterPage(),
        '/mainvaigation' : (context) => MainNavigation(),
       '/home/conversation' : (context) {
        final conversation = ModalRoute.of(context)?.settings.arguments as Conversation;
          return ConversationPage(conversation: conversation );
       }
      },
    );
  }
}