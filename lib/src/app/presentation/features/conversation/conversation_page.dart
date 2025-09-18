import 'dart:developer';

import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/presentation/features/conversation/bloc/conversation_cubit.dart';
import 'package:chat/src/app/presentation/features/conversation/bloc/conversation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ConversationPage extends StatefulWidget {
  final Conversation conversation;
  const ConversationPage({super.key,required this.conversation});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
 
  final _messageEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ScrollController _scrolController;

  void _scrolToPosition() {
    if (!_scrolController.hasClients) {
      return;
    }
    final maxEntent = _scrolController.position.maxScrollExtent;
    log('Max extent :$maxEntent');
    _scrolController.animateTo(
      maxEntent,
      duration: Duration(milliseconds: 600),
      curve: Curves.decelerate,
    );
  }

  @override
  void initState() {
    _scrolController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
     final Conversation(:id,:idContact) = widget.conversation;
     log('ID $id' );
     log('ID Contato $idContact' );
     context.read<ConversationCubit>().findAllMessages(id);
    });
  }

  @override
  void dispose() {
    _messageEC.dispose();
    _scrolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.read<ConversationCubit>();
    
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        titleSpacing: 1,
        title: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: CircleAvatar(
                radius: 30,
                 backgroundColor:  widget.conversation.contactimageUrl == null ? Colors.amberAccent : null,
                
                backgroundImage:  widget.conversation.contactimageUrl != null  ? NetworkImage(
                   widget.conversation.contactimageUrl!,
                ) : null,
              ),
            ),
            Text(widget.conversation.contactName),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocConsumer<ConversationCubit, ConversationState>(
             
              listener: (context, state) {
                if (state.status == ConversationStatus.error) {
                  ChatMessage.showError(
                    state.message ?? 'Erro ao buscar conversa',
                    context,
                  );
                }
                if (state.status == ConversationStatus.success && state.messages.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrolToPosition();
                  });
                }
              },
              builder: (context, state) {
                final ConversationState(:messages, :status, :message, :my) =
                    state;
                return switch (status) {
                  ConversationStatus.loading => ChatLoader(),
                  _ => Expanded(
                    child: Visibility(
                      replacement: Center(child: LottieBuilder.asset('assets/lottie/message.json',height: 240,)),
                      visible: messages.isNotEmpty,
                      child: ListView.builder(
                        controller: _scrolController,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Align(
                            alignment: message.senderId == my!.id
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.amberAccent.shade700.withAlpha(
                                    189,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(message.createdAt),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                };
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _messageEC,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Digite sua mensagem',
                      prefixIcon: Icon(Icons.camera_alt),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: IconButton.filled(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.black.withAlpha(50),
                            ),
                          ),
                          onPressed: () {
                            switch (_formKey.currentState?.validate() ??
                                false) {
                              case false:
                                {}
                              case true:
                                {  
                                  if (_messageEC.text.isEmpty) {
                                     return;
                                  }
                                  conversationBloc.sendMessage(
                                    _messageEC.text,
                                    widget.conversation,
                                  );
                                  _messageEC.clear();
                                }
                            }
                          },
                          icon: Icon(Icons.send, color: Colors.amber, size: 20),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                      ), // Altura do texto
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
