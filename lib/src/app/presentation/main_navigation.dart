import 'package:chat/src/app/presentation/features/contacts/contacts_page.dart';
import 'package:chat/src/app/presentation/features/home/home_page.dart';
import 'package:chat/src/app/presentation/features/story/story_page.dart';
import 'package:flutter/material.dart';
    
class MainNavigation extends StatefulWidget {

  const MainNavigation({ super.key });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int pageIndex = 0;
  List<Widget> pages = [
      HomePage(),
      StoryPage(),
      ContactsPage()
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
          NavigationDestination(icon: Icon(Icons.home), label:'Home'),
          NavigationDestination(icon: Icon(Icons.change_circle_outlined), label:'Story'),
          NavigationDestination(icon: Icon(Icons.contacts), label:'Contacts'),
        ] 
        ),
    );
  }
}