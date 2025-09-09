import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/usecase/find_short_videos.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_cubit.dart';
import 'package:chat/src/app/presentation/features/story/story_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryRouter {
  static final route = BlocProvider(
    create: (context) =>
        StoryCubit(findShortVIdeos: getIt.get<FindShortVideos>())
          ..finalAllShortsVideos(null),
    child: StoryPage(),
  );

  static Map<String, WidgetBuilder> routers() => {
    '/home/story': (_) => BlocProvider(
      create: (context) {
        final videos =
            ModalRoute.of(context)?.settings.arguments as List<Video>?;
        return StoryCubit(findShortVIdeos: getIt.get<FindShortVideos>())
          ..finalAllShortsVideos(videos);
      },
      child: StoryPage(),
    ),
  };
}/* 
 final videos = ModalRoute.of(context)?.settings.arguments as List<Video>;
          return StoryPage(video:videos ); */