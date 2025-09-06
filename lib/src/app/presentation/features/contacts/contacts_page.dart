import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/contact_info_widget.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
import 'package:chat/src/app/domain/model/user.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_cubit.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final contactBloc = getIt.get<ContactCubit>();
  final List<User> contactFound = [];
  final _searchEC = TextEditingController();

  @override
  void dispose() {
    _searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<ContactCubit, ContactState>(
                bloc: contactBloc,
                listener: (context, state) {
                  if (state.status == ContactStatus.error) {
                    ChatMessage.showError(
                      state.message ?? 'erro ao buscar contato',
                      context,
                    );
                  }
                },
                builder: (context, state) {
                  final ContactState(:status) = state;
                  return SearchBar(
                    controller: _searchEC,
                    trailing: [
                      status == ContactStatus.loading
                          ? CircularProgressIndicator(
                              color: Colors.amber,
                              strokeAlign: .5,
                              strokeWidth: 1,
                            )
                          : IconButton(
                              onPressed: () {
                                contactBloc.findUserByEmail(_searchEC.text);
                              },
                              icon: Icon(Icons.add),
                            ),
                    ],
                    leading: Icon(Icons.search),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.grey.withAlpha(200)),
                    ),
                    hintText: 'Find contact',

                    onSubmitted: (value) {
                      contactBloc.findUserByEmail(value);
                    },
                    onChanged: (value) {},
                  );
                },
              ),
              Text(
                'My contacts',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              BlocBuilder<ContactCubit, ContactState>(
                bloc: contactBloc,
                builder: (context, state) {
                  final ContactState(:status, :contact) = state;
                  return switch (status) {
                    ContactStatus.success => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: [contact].length,
                        itemBuilder: (context, index) {
                          return ContactInfoWidget.withIcon(
                            title: contact!.name,
                            description: contact.email,
                            icon: Icons.message,
                            onTap: () {
                              final privateConversation = Conversation(
                                contactimageUrl: contact.urlImage,
                                idContact: contact.id!,
                                lastMassage: '',
                                timeLastMessage: DateTime.now(),
                                contactName: contact.name,
                              );
                              Navigator.of(context).pushNamed(
                                '/home/conversation',
                                arguments: privateConversation,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    _ => SizedBox.shrink(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
