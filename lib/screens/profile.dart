import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/widgets/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/providers.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(context, WidgetRef ref) {
    print(ref.watch(profilePhotoProvider));
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                color: Colors.red,
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) => curUser.reset(ref));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ]),
        body: profileCard(ref, false));
  }
}
