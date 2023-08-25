import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/screens/feed.dart';
import 'package:sasa_mobile_app/screens/login_flow/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sasa_mobile_app/screens/splash.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const FeedScreen();
            }
            return const LoginScreen();
          }),
    ),
  );
}
