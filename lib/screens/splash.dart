import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            "Sasa",
            style: TextStyle(
              fontSize: 50,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
