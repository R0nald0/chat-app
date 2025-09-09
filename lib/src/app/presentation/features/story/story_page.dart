import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/chat_video_widget.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/usecase/find_short_videos.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_cubit.dart';
import 'package:chat/src/app/presentation/features/story/bloc/story_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryPage extends StatelessWidget {
  final List<Video>? _storys;

  const StoryPage({super.key, List<Video>? video}) : _storys = video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _storys != null && _storys.isNotEmpty ?AppBar() :null,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
      ),
      body: BlocProvider(
        create: (context) =>
            StoryCubit(findShortVIdeos: getIt.get<FindShortVideos>())
              ..finalAllShortsVideos(_storys),
        child: BlocConsumer<StoryCubit, StoryState>(
          listener: (context, state) {
            if (state.status == StoryStatus.error) {
              ChatMessage.showError(
                state.message ?? 'Erro ao buscar os videos',
                context,
              );
            }
          },
          builder: (context, state) {
            final StoryState(:message, :shortsVideos, :status) = state;
            return switch (state.status) {
              StoryStatus.loading => ChatLoader(),

              StoryStatus.initial => Center(child: Text('Buscando videos...')),
              _ => PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: shortsVideos.length,
                itemBuilder: (context, index) {
                  final video = shortsVideos[index];
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: ChatVideoWidget(
                        duration: video.duration,
                        nameOwner: video.ownerName,
                        urlImage: video.ownerUrlImge,
                        urlVideo: video.urlVideo,
                        desciption: video.descrition,
                        onFavorite: () {},
                      ),
                    ),
                  );
                },
              ),
            };
          },
        ),
      ),
    );
  }
}
