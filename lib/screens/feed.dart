import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      body: const Center(
        child: Text("Feed Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();

          //Navigator.push(context, MaterialPageRoute(builder: (context) {
          //  return const Profile();
          //}));
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
