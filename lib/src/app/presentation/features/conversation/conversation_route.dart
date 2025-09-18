import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/usecase/create_conversation_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_all_message_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/domain/usecase/received_message_user_case.dart';
import 'package:chat/src/app/domain/usecase/send_message_use_case.dart';
import 'package:chat/src/app/presentation/features/conversation/bloc/conversation_cubit.dart';
import 'package:chat/src/app/presentation/features/conversation/conversation_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationRoute {
  static Map<String, WidgetBuilder> route = {
    '/home/conversation': (context) {
      final conversation =
          ModalRoute.of(context)?.settings.arguments as Conversation;
      return BlocProvider(
        create: (context) => ConversationCubit(
          createConversationUseCase: getIt.get<CreateConversationUseCase>(),
          chatServiceSockte: getIt.get<ChatServiceSockte>(),
          findAllMessageUseCase: getIt.get<FindAllMessageUseCase>(),
          findMyUseCase: getIt.get<FindMyUseCase>(),
          receivedMessageUseCase: getIt.get<ReceivedMessageUserCase>(),
          sendMessageUseCase: getIt.get<SendMessageUseCase>(),
        ),
        child: ConversationPage(conversation: conversation),
      );
    },
  };
}
