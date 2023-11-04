import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/widgets/chat_messages.dart';
import 'package:sasa_mobile_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
