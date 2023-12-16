import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/chat.dart';
import 'package:sasa_mobile_app/widgets/chat_messages.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: ListView.builder(
            itemCount: curUser.matches.length,
            itemBuilder: ((context, index) {
              print(curUser.matches.length);
              var url = getUserDoc(index);
              return GestureDetector(
                child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
                    future: getUserDoc(index),
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: (() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ChatScreen(snapshot.data![1].id);
                          }));
                        }),
                        child: Column(
                          children: [
                            const Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: snapshot.hasData
                                      ? Image.network(snapshot.data![0]["profile_photo_url"]).image
                                      : const AssetImage("assets/images/default_photo.png"),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  snapshot.hasData ? snapshot.data![0]["name"] : "",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                            const Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      );
                    }),
              );
            })));
  }
}

Future<List<DocumentSnapshot<Map<String, dynamic>>>> getUserDoc(index) async {
  var doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  var docRef = doc.data()!["matches"][index];

  final match = await FirebaseFirestore.instance.collection('matches').doc(docRef).get();

  docRef = match.data()!["userId1"];

  doc = await FirebaseFirestore.instance.collection('users').doc(docRef).get();

  return [doc, match];
}
