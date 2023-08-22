import 'package:flutter/material.dart';

Widget letsMeetTheRealYou() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's meet the real you...",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text("Keep your answers as authentic as possible"),
          styledTextFormField("Describe your ideal weekend..."),
          styledTextFormField("What's your biggest green flag?..."),
          styledTextFormField(
              "If your life was a movie, which one would it be?"),
        ]),
  );
}

Widget styledTextFormField(String labelText, {Widget? suffixIcon}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Colors.grey.shade200,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      suffixIcon: suffixIcon,
    ),
  );
}
