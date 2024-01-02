import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages(this.matchId, {super.key});

  String? matchId;
  List<String> readMessages = [];

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(matchId)
            .collection("chats")
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }

          if (snapshots.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          final loadedMessages = snapshots.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage =
                  index + 1 < loadedMessages.length ? loadedMessages[index + 1].data() : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId = nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                print("Here");
                return MessageBubble.next(
                    message: chatMessage['message'],
                    isMe: authenticatedUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['name'],
                  message: chatMessage['message'],
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              }
              //Text(loadedMessages[index].data()['message']);
            },
          );
        });
  }
}
