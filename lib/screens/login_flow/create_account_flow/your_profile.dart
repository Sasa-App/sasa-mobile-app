import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:sasa_mobile_app/models/profile_details.dart';
import 'package:sasa_mobile_app/providers.dart';

class YourProfile extends ConsumerWidget {
  YourProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Your Profile...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/sasa_guy.jpg"),
            ),
            Text(ref.watch(nameProvider),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              "🎂 ${ref.watch(ageProvider)}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              ref.watch(nationalityProvider),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              ref.watch(universityProvider),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.red,
              thickness: 1,
            ),
            styledTextFormField("Describe your ideal weekend"),
          ]),
    );
  }
}

/*
Widget yourProfile() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Your Profile...",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/images/sasa_guy.jpg"),
          ),
          const Text("Prince",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text(
            "🎂 21",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Ghanaian",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Text(
            "🎓 University of Nottingham",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: Colors.red,
            thickness: 1,
          ),
          styledTextFormField("Describe your ideal weekend"),
        ]),
  );
}
*/

Widget styledTextFormField(String labelText, {Widget? suffixIcon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        labelText,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      TextFormField(
        decoration: InputDecoration(
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
      ),
    ],
  );
}
