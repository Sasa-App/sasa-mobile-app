import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/widgets/chat_messages.dart';
import 'package:sasa_mobile_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.matchId, {super.key});

  String matchId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ChatMessages(widget.matchId)),
          NewMessage(widget.matchId),
        ],
      ),
    );
  }
}
