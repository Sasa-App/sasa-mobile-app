import 'package:flutter/material.dart';

Widget selectAProfilePhoto() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select a profile photo",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text("Be sure to choose your best one!"),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              "Sign in",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
  );
}
