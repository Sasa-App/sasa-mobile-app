import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/screens/profile.dart';

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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const Profile();
          }));
        },
        child: const Icon(Icons.arrow_circle_right_sharp),
      ),
    );
  }
}
