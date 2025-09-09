import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/core/ui/widgets/contact_info_widget.dart';
import 'package:chat/src/app/domain/model/conversation.dart';
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
  final _searchEC = TextEditingController();
  var showResultSearch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    
    });
  }

  @override
  void dispose() {
    _searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final  contactBloc = context.read<ContactCubit>();
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
                listener: (context, state) {
                  if (state.status == ContactStatus.error) {
                    showResultSearch = false;
                   
                    ChatMessage.showError(
                      state.message ?? 'Conto não encontrado',
                      context,
                    );
                  }
                },
                builder: (context, state) {
                  final ContactState(:status, :contact) = state;
                  return Column(
                    spacing: 10,
                    children: [
                      SearchBar(
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
                                    verifySearchText(_searchEC.text,contactBloc);
                                     _searchEC.text = '';
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

                        onSubmitted: (email) {
                          verifySearchText(email,contactBloc);
                           _searchEC.text = '';
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            showResultSearch = false;
                            context.read<ContactCubit>().findUserByEmail(value);
                          }
                        },
                      ),
                      Visibility(
                        replacement: SizedBox.shrink(),
                        visible :status == ContactStatus.findUser &&
                            showResultSearch && contact != null
                            , 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Found',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ContactInfoWidget(
                              title: contact?.name ?? "No user",
                              description: contact?.email ?? 'No email',
                              imageUrl: contact?.urlImage,
                              icon: Visibility(
                                replacement: FractionallySizedBox(
                                  widthFactor: 0.06,
                                  child: ChatLoader(size: 20),
                                ),
                                visible: status == ContactStatus.findUser,
                                child: Icon(Icons.add),
                              ),
                              onTap: () {
                                if (contact?.id != null &&
                                    status == ContactStatus.findUser) {
                                  contactBloc.addContact(contact!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              Text(
                'My contacts',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              BlocBuilder<ContactCubit, ContactState>(
               
                builder: (context, state) {
                  final ContactState(:status, :contacts) = state;
                  return Expanded(
                    child: Visibility(
                      replacement: Center(child: Text('Find your contacts')),
                      visible: contacts.isNotEmpty,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final myContatc = contacts[index];
                          return ContactInfoWidget.withIcon(
                            title: myContatc.name,
                            imageUrl: myContatc.urlImage,
                            description: myContatc.email,
                            icon: Icon(Icons.message),
                            onTap: () {
                              final privateConversation = Conversation(
                                contactimageUrl: myContatc.urlImage,
                                idContact: myContatc.id!,
                                lastMassage: '',
                                timeLastMessage: DateTime.now(),
                                contactName: myContatc.name,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifySearchText(String email ,ContactCubit contactBloc) {
    if (email.isNotEmpty) {
      contactBloc.findUserByEmail(email);
      showResultSearch = true;
    }
  }
}
