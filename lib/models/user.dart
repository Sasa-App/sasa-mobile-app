import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/models/matches.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  HashSet<String> likedUsers = HashSet<String>();
  HashSet<String> dislikedUsers = HashSet<String>();
  HashSet<String> matches = HashSet<String>();

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
    matches = userData.data().toString().contains("matches")
        ? HashSet.from(userData.get("matches"))
        : matches;
    likedUsers = userData.toString().contains("likedUsers")
        ? HashSet.from(userData.get("likedUsers"))
        : likedUsers;
    dislikedUsers = userData.toString().contains("dislikedUsers")
        ? HashSet.from(userData.get("dislikedUsers"))
        : dislikedUsers;

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
    likedUsers = HashSet<String>();
    dislikedUsers = HashSet<String>();
    matches = HashSet<String>();
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

  Future<double> getCurPage() async {
    var pref = await SharedPreferences.getInstance();
    var curPage = pref.getDouble("curPage") ?? 0;
    return curPage;
  }

  Future<void> saveCurPage(double curPage) async {
    var pref = await SharedPreferences.getInstance();
    pref.setDouble("curPage", curPage);
  }

  Future<void> clearMemory() async {
    var pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> checkMatch(String userRef) async {
    curUser.likedUsers.add(userRef);

    final curUserId = FirebaseAuth.instance.currentUser!.uid;
    final potentialMatch = await FirebaseFirestore.instance.collection('users').doc(userRef).get();

    HashSet<String> potentialMatchLikes = potentialMatch.data().toString().contains("likedUsers")
        ? HashSet.from(potentialMatch.get("likedUsers"))
        : HashSet<String>();

    if (potentialMatchLikes.contains(curUserId)) {
      final docRef = await Matches(potentialMatch.id, curUserId).createMatch();
      matches.add(docRef);
      updateMatches(potentialMatch.id, curUserId, docRef);
      return true;
    }

    return false;
  }

  void updateLikesOrDislikes() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'likedUsers': likedUsers,
      'dislikedUsers': dislikedUsers,
    }).onError((error, stackTrace) async {
      print("oH OH Erro hERE");
    });
  }

  void updateMatches(matchedUserId, curUserId, matchRef) async {
    await FirebaseFirestore.instance.collection('users').doc(matchedUserId).update({
      'matches': FieldValue.arrayUnion([matchRef]),
    }).onError((error, stackTrace) async {
      print("oH OH Erro hERE");
    });

    await FirebaseFirestore.instance.collection('users').doc(curUserId).update({
      'matches': matches,
    }).onError((error, stackTrace) async {
      print("oH OH Erro hERE");
    });
  }

/*

await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'name': curUser.name,
          'age': curUser.age,
          'nationality': curUser.nationality,
          'university': curUser.university,
          'email': curUser.email,
          'profile_photo_url': curUser.profilephotoUrl,
          'lookingFor': curUser.looking4.toString(),
          'idealWeekend': curUser.idealWeekend,
          'greenFlags': curUser.greenFlags,
          'lifeMovie': curUser.lifeMovie
        }).onError((error, stackTrace) async {
          await storageRef.delete();
        });
        */
}
