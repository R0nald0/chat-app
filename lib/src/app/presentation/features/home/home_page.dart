import 'dart:developer';

import 'package:chat/src/app/core/extension/data_extension.dart';
import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/core/ui/widgets/contact_wiget.dart';
import 'package:chat/src/app/data/dto/story_dto.dart';
import 'package:chat/src/app/domain/model/videos.dart';
import 'package:chat/src/app/domain/usecase/find_my_use_case.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_state.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_cubit.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  final authCubit = getIt.get<AuthCubit>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final navigate = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Messages'),
        actions: [
          BlocListener<AuthCubit, AuthState>(
            bloc: authCubit,
            listener: (context, state) {
              if (state.status == AuthStatus.error) {
                ChatMessage.showError(
                  state.message ?? 'erro ao delogar usuário',
                  context,
                );
              }
              if (state.status == AuthStatus.success) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
            child: IconButton(
              onPressed: () {
                authCubit.logout();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                BlocSelector<HomeCubit, HomeState, List<StoryDto>>(
                  selector: (state) {
                    if (state.status == HomeStatus.successStorys) {
                      return state.story;
                    }
                    return [];
                  },
                  builder: (context, state) {
                    return RecentsSection(story: state);
                  },
                ),
                SliverFillRemaining(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(32),
                      ),
                      color: const Color.fromARGB(221, 23, 29, 1),
                    ),
                    child: BlocConsumer<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state.status == HomeStatus.error) {
                          ChatMessage.showError(
                            state.message ??
                                'erro ao buscar conversas do usuário',
                            context,
                          );
                        }
                      },
                      builder: (context, state) {
                        final HomeState(
                          :conversations,
                          :message,
                          :status,
                          :user,
                        ) = state;

                        return switch (status) {
                          HomeStatus.initial => Center(
                            child: Text('Buscando dados'),
                          ),
                          HomeStatus.error => Center(
                            child: Text('Ops Algo deu errado !!!!!'),
                          ),
                          HomeStatus.loading => ChatLoader(),
                          _ => Visibility(
                            visible: conversations.isNotEmpty,
                            replacement: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset('assets/lottie/conversation.json',height: 240,),
                                Text('Nenhuma conversa'),
                              ],
                            ),
                            child: ListView.builder(
                              itemCount: conversations.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 18,
                              ),
                              itemBuilder: (context, index) {
                                final conversation = conversations[index];
                                log(
                                  'last Messa  ${conversation.lastMassage.content}',
                                );
                                return ListTile(
                                  title: Text(
                                    conversation.contactName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Visibility(
                                            visible:
                                                conversation.idContact ==
                                                conversation.lastMassage.senderId,
                                            child: Icon(
                                              Icons.done_all,
                                              size: 20,
                                              color:
                                                  conversation.unreadMessages == 
                                                      0 && conversation.idContact !=
                                                user?.id
                                                  ? Colors.blue
                                                  : Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ${conversation.lastMassage.content}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible:
                                        conversation.unreadMessages != 0 &&
                                        conversation.idContact == conversation.lastMassage.senderId,
                                    replacement: Text(
                                      maxLines: 1,
                                         conversation.lastMassage.createdAt ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.amber,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${conversation.unreadMessages}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        conversation.contactimageUrl == null
                                        ? Colors.amberAccent
                                        : null,
                                    backgroundImage:
                                        conversation.contactimageUrl != null
                                        ? NetworkImage(
                                            conversation.contactimageUrl!,
                                          )
                                        : null,
                                  ),
                                  onTap: () async {
                                   
                                  await  navigate.pushNamed(
                                      '/home/conversation',
                                      arguments: conversation,
                                    );
                                    await  homeCubit.updateReadConversationMessages(conversation.id!);
                                    await homeCubit.findStoryMyContacts();
                                  },
                                );
                              },
                            ),
                          ),
                        };
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RecentsSection extends StatelessWidget {
 
  final List<StoryDto> story;
  const RecentsSection({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
     final navigate = Navigator.of(context);
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
              child: Text(
                "Story",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: story.length,
               
                itemBuilder: (context, index) {
                  final storyDto = story[index];
                  return StoryContactWiget(
                    name: storyDto.name,
                    urlImage: storyDto.imageUrl,
                    onTap: ()async {
                      if (storyDto.storys.isEmpty   || index   == 0) {
                         final user =await getIt.get<FindMyUseCase>().call();
                         navigate.pushNamed('/story/camera',arguments:user);
                        return;
                      }
                      final videos = storyDto.storys
                          .map(
                            (s) => Video.fromVideoDto(
                              storyDto.name,
                              storyDto.imageUrl,
                              s,
                            ),
                          )
                          .toList();
                      
                        Navigator.of(context).pushNamed(
                          '/home/story',
                          arguments: videos,
                        );
                    
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
