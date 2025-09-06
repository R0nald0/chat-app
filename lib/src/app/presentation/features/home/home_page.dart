import 'package:chat/src/app/core/extension/data_extension.dart';
import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/core/ui/widgets/contact_wiget.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_cubit.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeBloc;

  @override
  void initState() {
    homeBloc = getIt.get<HomeCubit>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeBloc.findAllByUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Messages')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                RecentsSection(),
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
                      bloc: homeBloc,
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
                        final HomeState(:conversations, :message, :status,) =
                            state;
                        return switch (status) {
                          HomeStatus.initial => Center(
                            child: Text('Buscando dados'),
                          ),
                          HomeStatus.error => Center(
                            child: Text('Ops Algo deu errado !!!!!'),
                          ),
                          HomeStatus.success => Visibility(
                            visible: conversations.isNotEmpty,
                            replacement: Center(
                              child: Text('Nenhuma conversa'),
                            ),
                            child: ListView.builder(
                              itemCount: conversations.length,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                              itemBuilder: (context, index) {
                                final conversation = conversations[index];
                                return ListTile(
                                  title: Text(conversation.contactName,
                                  style:TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                  ) ,),
                                  subtitle: RichText(
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 1,
                                     text: TextSpan(
                                     style:TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16
                                  ),
                                      children: [
                                          WidgetSpan(child: Icon(Icons.done_all,size: 20,color: Colors.blueGrey,)),
                                          TextSpan(
                                            text:' ${conversation.lastMassage}',
                                          )
                                      ]
                                     ) 
                                    ),
                                  trailing: Text(conversation.timeLastMessage.formatedToStringDayMinute(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                  ),

                                  leading: CircleAvatar(
                                    radius: 30,
                                     backgroundColor: conversation.contactimageUrl == null ? Colors.amberAccent : null,
                                    backgroundImage:conversation.contactimageUrl != null  ?NetworkImage(
                                      conversation.contactimageUrl!    
                                    ) : null,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/home/conversation',
                                       arguments: conversation,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          HomeStatus.loading => ChatLoader(),
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
  const RecentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 160,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
              child: Text("Stores",style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ContactWiget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
