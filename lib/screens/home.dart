import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/chat.dart';
import 'package:sasa_mobile_app/screens/chats.dart';
import 'package:sasa_mobile_app/screens/feed.dart';
import 'package:sasa_mobile_app/screens/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 1;
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Widget> tabs = [const ChatsListScreen(), FeedScreen(), const Profile()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: tabs[widget.selectedIndex],
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
              curUser.downloadUserDoc(ref);
              widget.selectedIndex = index;
            });
            ;
          }),
        ),
      ),
    );
  }
}
