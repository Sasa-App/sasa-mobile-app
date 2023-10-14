import 'package:flutter/material.dart';

class LookingFor extends StatefulWidget {
  const LookingFor({super.key});

  @override
  State<LookingFor> createState() => _LookingForState();
}

class _LookingForState extends State<LookingFor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.pink.shade200),
                    ),
                    child: const Text(
                      "Flirting 💗 ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                    child: const Text(
                      "Friendship 👥",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}

/*
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pink.shade200),
                  ),
                  child: const Text(
                    "Flirting 💗 ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                  child: const Text(
                    "Friendship 👥",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ]),
  );
}
*/