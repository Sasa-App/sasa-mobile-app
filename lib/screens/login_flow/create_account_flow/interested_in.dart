import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterestedIn extends ConsumerWidget {
  const InterestedIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Interested in...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            //const Text("We'll connect you to other users with similar answers"),
            Expanded(
              child: StatefulBuilder(builder: (context, setState) {
                Color isMaleColor = ref.read(interstedInProvider.notifier).state == Interest.men
                    ? Colors.red
                    : Colors.transparent;
                Color isFemaleColor = ref.read(interstedInProvider.notifier).state == Interest.women
                    ? Colors.red
                    : Colors.transparent;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          ref.read(interstedInProvider.notifier).state = Interest.men;
                        });
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(color: isMaleColor, width: 3)),
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      child: const Text(
                        "Men",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          ref.read(interstedInProvider.notifier).state = Interest.women;
                        });
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(color: isFemaleColor, width: 3)),
                        backgroundColor: MaterialStateProperty.all(Colors.pink.shade200),
                      ),
                      child: const Text(
                        "Women",
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
