

import 'package:chat/src/app/core/services/chat_service_sockte.dart';
import 'package:chat/src/app/data/datasource/chat_auth_rest_client.dart';
import 'package:chat/src/app/data/datasource/chat_conversation_rest_client.dart';
import 'package:chat/src/app/data/datasource/chat_message_data_souce.dart';
import 'package:chat/src/app/data/datasource/chat_user_rest_client.dart';
import 'package:chat/src/app/data/repository/auth_repository_impl.dart';
import 'package:chat/src/app/data/repository/conversation_repository.dart';
import 'package:chat/src/app/data/repository/find_my_repository_impl.dart';
import 'package:chat/src/app/data/repository/message_repository_impl.dart';
import 'package:chat/src/app/data/repository/user_repository_impl.dart';
import 'package:chat/src/app/data/repository/videos_shorts_repository.dart';
import 'package:chat/src/app/domain/repository/auth_repository.dart';
import 'package:chat/src/app/domain/repository/conversation_repository.dart';
import 'package:chat/src/app/domain/repository/find_my_repository.dart';
import 'package:chat/src/app/domain/repository/message_repository.dart';
import 'package:chat/src/app/domain/repository/short_video_repository.dart';
import 'package:chat/src/app/domain/repository/user_repository.dart';
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_all_message_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_by_email_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_short_videos.dart';
import 'package:chat/src/app/domain/usecase/login_use_case.dart';
import 'package:chat/src/app/domain/usecase/received_message_user_case.dart';
import 'package:chat/src/app/domain/usecase/register_use_case.dart';
import 'package:chat/src/app/domain/usecase/send_message_use_case.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_cubit.dart';
import 'package:chat/src/app/presentation/features/conversation/bloc/conversation_cubit.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_cubit.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(()=> FlutterSecureStorage());
  getIt.registerLazySingleton(() => ChatConversationRestClient(
    storage: getIt.get<FlutterSecureStorage>()
  ));
    
    getIt.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(
      chatConversationRestClient: getIt.get<ChatConversationRestClient>(),
    ),
  );

  //Auth
   getIt.registerLazySingleton(() => ChatAuthRestClient());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(chatRestClient: getIt.get<ChatAuthRestClient>(), storage:  getIt.get<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton(
    () => LoginUseCase(authRepository: getIt.get<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => RegisterUseCase(authRepository: getIt.get<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: getIt.get<LoginUseCase>(),
      registrtUseCase: getIt.get<RegisterUseCase>(),
    ),
  );

  //Contact
  getIt.registerLazySingleton(() => ChatUserRestClient(storage: getIt.get<FlutterSecureStorage>()));

   getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userRestClient: getIt.get<ChatUserRestClient>()),
  );
  getIt.registerLazySingleton(
    () => FindByEmailUseCase(
      userRepository: getIt.get<UserRepository>(),
    ),
  );
    
   getIt.registerLazySingleton(
    () => ContactCubit(
     findByEmail: getIt.get<FindByEmailUseCase>()
    ),
  );

   //Home
   
   getIt.registerLazySingleton(
    () => ConversationUseCase(
      conversationRepository: getIt.get<ConversationRepository>(),
    ),
  );

   getIt.registerLazySingleton(
    () => HomeCubit(
     conversationUseCase: getIt.get<ConversationUseCase>()
    ),
  );
  //COnversation
   
  getIt.registerLazySingleton(() => ChatMessageDataSouce(
    sercureStorage: getIt.get<FlutterSecureStorage>()
  ));
  
  getIt.registerLazySingleton(() => ChatServiceSockte());

  getIt.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl(
    chatMessageDataSouce: getIt.get<ChatMessageDataSouce>(),
  ));
  
  
  
   getIt.registerLazySingleton(() => FindAllMessageUseCase(
    messageRepository: getIt.get<MessageRepository>()
  ));
   getIt.registerLazySingleton<FindMyRepository>(() => FindMyRepositoryImpl());
   getIt.registerLazySingleton(() => FindMyUseCase(
    findMyRepositorr: getIt.get<FindMyRepository>()
  ));
  
  getIt.registerLazySingleton(() => ReceivedMessageUserCase(
    messageRepository: getIt.get<MessageRepository>()
  ));
   getIt.registerLazySingleton(() => SendMessageUseCase(
    messageRepository: getIt.get<MessageRepository>()
  ));

   getIt.registerLazySingleton(
    () => ConversationCubit(
     findAllMessageUseCase: getIt.get<FindAllMessageUseCase>(),
     findMyUseCase: getIt.get<FindMyUseCase>(),
     receivedMessageUseCase: getIt.get<ReceivedMessageUserCase>(),
     sendMessageUseCase: getIt.get<SendMessageUseCase>()
    ),
  );


  //Story

getIt.registerLazySingleton<ShortVideoRepository>(() =>VideosShortsRepository());
getIt.registerLazySingleton(() => FindShortVideos(shortVideoRepository: getIt.get<ShortVideoRepository>()));
getIt.registerLazySingleton(()=>StoryCubit(findShortVIdeos: getIt.get<FindShortVideos>()));
}
