import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/providers.dart';

class NewMessage extends StatefulWidget {
  NewMessage(this.matchId, {super.key});

  String? matchId;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessge() async {
    print("here");
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.matchId)
        .collection('chats')
        .add({
      'message': enteredMessage,
      'createdAt': FieldValue.serverTimestamp(), //Timestamp.now(),
      'userId': user.uid,
      'name': curUser.doc!["name"],
      'userImage': curUser.doc!["profile_photo_url"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: 'Send a message...'),
          ),
        ),
        IconButton(
          color: Colors.red,
          onPressed: () {
            _submitMessge();
          },
          icon: const Icon(Icons.send),
        )
      ]),
    );
  }
}
