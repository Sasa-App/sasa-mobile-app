import 'package:flutter/material.dart';

Widget lookingFor() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Looking for...",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text("We'll connect you to other users with similar answers"),
          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              "Flirting 💗 ",
              style: TextStyle(color: Colors.white),
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              "Friendship 👥",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ]),
  );
}
