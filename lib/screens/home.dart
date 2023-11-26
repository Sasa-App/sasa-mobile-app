import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/chat.dart';
import 'package:sasa_mobile_app/screens/feed.dart';
import 'package:sasa_mobile_app/screens/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 1;
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Widget> tabs = [const ChatScreen(), FeedScreen(), const Profile()];
  @override
  void initState() {
    curUser.reloadDetails(ref);
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: tabs[widget.selectedIndex],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: widget.selectedIndex,
          selectedItemColor: Colors.red,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble,
                  size: 30,
                ),
                label: "Convos"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: 30,
                ),
                label: "Feed"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                label: "Profile"),
          ],
          onTap: ((index) {
            setState(() {
              widget.selectedIndex = index;
            });
            ;
          }),
        ),
      ),
    );
  }
}
