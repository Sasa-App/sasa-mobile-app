import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LookingFor extends ConsumerWidget {
  LookingFor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: StatefulBuilder(builder: (context, setState) {
                Color isFlirtingColor =
                    ref.read(looking4Provider.notifier).state ==
                            Looking4.aGoodTime
                        ? Colors.red
                        : Colors.transparent;
                Color isFriendshipColor =
                    ref.read(looking4Provider.notifier).state ==
                            Looking4.aLongTime
                        ? Colors.red
                        : Colors.transparent;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          ref.read(looking4Provider.notifier).state =
                              Looking4.aGoodTime;
                        });
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: isFlirtingColor, width: 3)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink.shade200),
                      ),
                      child: const Text(
                        "A good time 😉 ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          ref.read(looking4Provider.notifier).state =
                              Looking4.aLongTime;
                        });
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: isFriendshipColor, width: 3)),
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      child: const Text(
                        "A long time 🤞🏿",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              }),
            )
          ]),
    );
  }
}
