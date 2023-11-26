import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'dart:io';

enum Looking4 { aGoodTime, aLongTime, none }

class CurUser {
  String name = "";
  String age = "";
  String nationality = "";
  String university = "";
  String email = "";
  String password = "";
  String idealWeekend = "";
  String greenFlags = "";
  String lifeMovie = "";
  Looking4 looking4 = Looking4.none;
  String profilephotoUrl = "assets/images/default_photo.png";

  Future<bool> reloadDetails(WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    /*
    email =
        "${ref.read(emailProvider.notifier).state}${universities[ref.watch(universityProvider)]}";
    password = ref.read(passwordProvider.notifier).state;
    name = ref.read(nameProvider.notifier).state;
    age = ref.read(ageProvider.notifier).state;
    university = ref.read(universityProvider.notifier).state;
    nationality = ref.read(nationalityProvider.notifier).state;
    looking4 = ref.read(looking4Provider.notifier).state;
    idealWeekend = ref.read(idealWeekendProvider.notifier).state;
    greenFlags = ref.read(greenFlagsProvider.notifier).state;
    lifeMovie = ref.read(lifeMovieProvider.notifier).state;
    */

    email = userData.get('email');
    name = userData.get('name');
    age = userData.get('age');
    university = userData.get('university');
    nationality = userData.get('nationality');
    looking4 = Looking4.values.firstWhere((e) => e.toString() == userData.get('lookingFor'));
    idealWeekend = userData.get('idealWeekend');
    greenFlags = userData.get('greenFlags');
    lifeMovie = userData.get('lifeMovie');
    profilephotoUrl = userData.get("profile_photo_url");

    ref.invalidate(nameProvider);
    ref.invalidate(emailProvider);
    ref.invalidate(nationalityProvider);
    ref.invalidate(ageProvider);
    ref.invalidate(universityProvider);
    ref.invalidate(profilePhotoProvider);
    ref.invalidate(passwordProvider);
    ref.invalidate(lifeMovieProvider);
    ref.invalidate(looking4Provider);
    ref.invalidate(greenFlagsProvider);
    ref.invalidate(idealWeekendProvider);
    return true;
  }

  void reset(WidgetRef ref) {
    name = "";
    age = "";
    nationality = "";
    university = "";
    email = "";
    password = "";
    idealWeekend = "";
    greenFlags = "";
    lifeMovie = "";
    looking4 = Looking4.none;
    profilephotoUrl = "assets/images/default_photo.png";

    ref.invalidate(nameProvider);
    ref.invalidate(emailProvider);
    ref.invalidate(nationalityProvider);
    ref.invalidate(ageProvider);
    ref.invalidate(universityProvider);
    ref.invalidate(profilePhotoProvider);
    ref.invalidate(passwordProvider);
    ref.invalidate(lifeMovieProvider);
    ref.invalidate(looking4Provider);
    ref.invalidate(greenFlagsProvider);
    ref.invalidate(idealWeekendProvider);
  }
}
