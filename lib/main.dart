import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/screens/login_flow/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: LoginScreen(),
    ),
  );
}
