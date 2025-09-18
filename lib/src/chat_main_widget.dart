import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/theme/chat_app_them.dart';
import 'package:chat/src/app/core/ui/widgets/chat_camera.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/usecase/find_short_videos.dart';
import 'package:chat/src/app/presentation/features/auth/auth_router.dart';
import 'package:chat/src/app/presentation/features/conversation/conversation_route.dart';
import 'package:chat/src/app/presentation/features/splashcreen/splash_screen_page.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_cubit.dart';
import 'package:chat/src/app/presentation/features/story/story_page.dart';
import 'package:chat/src/app/presentation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMainWidget extends StatelessWidget {
  const ChatMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ChatAppTheme.dark,
      initialRoute: '/splash-screen',
      routes: {
        '/splash-screen': (context) => SplashScreenPage(),
        '/story/camera': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User;
         return  BlocProvider(
            create: (context) => StoryCubit(findShortVIdeos: getIt.get<FindShortVideos>()),
            child: ChatCamera(my: user,),
           );
        },
        '/mainvaigation': (context) => MainNavigation(),
         ...AuthRouter.route,
        ...AuthRouter.routeRegister,
        ...ConversationRoute.route,
        '/home/story': (context) {
          final videos =
              ModalRoute.of(context)?.settings.arguments as List<Video>;
          return StoryPage(video: videos);
        },
      },
    );
  }
}
