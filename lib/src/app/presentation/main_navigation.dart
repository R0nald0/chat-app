import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/domain/usecase/add_contact.dart';
import 'package:chat/src/app/domain/usecase/conversation_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_by_email_use_case.dart';
import 'package:chat/src/app/domain/usecase/find_my_contacts.dart';
import 'package:chat/src/app/domain/usecase/find_story_my_contacts.dart';
import 'package:chat/src/app/domain/usecase/login_use_case.dart';
import 'package:chat/src/app/domain/usecase/lout_use_case.dart';
import 'package:chat/src/app/domain/usecase/register_use_case.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/contacts/bloc/contact_cubit.dart';
import 'package:chat/src/app/presentation/features/contacts/contacts_page.dart';
import 'package:chat/src/app/presentation/features/home/bloc/home_cubit.dart';
import 'package:chat/src/app/presentation/features/home/home_page.dart';
import 'package:chat/src/app/presentation/features/story/story_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int pageIndex = 0;
  List<Widget> pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(
          loginUseCase: getIt.get<LoginUseCase>(), 
          registrtUseCase: getIt.get<RegisterUseCase>(), 
          logoutUseCse: getIt.get<LogoutUseCase>()
          ),),
        BlocProvider(
          create: (context) => HomeCubit(
            conversationUseCase: getIt.get<ConversationUseCase>(),
            findStoryMyContacts: getIt.get<FindStoryMyContacts>(),
          )..findAllByUser()
          ..findStoryMyContacts(),
        ),
      ],
      child: HomePage(),
    ),
    StoryPage(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactCubit(
            findByEmail: getIt.get<FindByEmailUseCase>(),
            findMyContacts: getIt.get<FindMyContacts>(),
            addContact: getIt.get<AddContact>(),
          )..findMyContacts(),
        ),
      ],
      child: ContactsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        selectedIndex: pageIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.change_circle_outlined),
            label: 'Story',
          ),
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
      ),
    );
  }
}
