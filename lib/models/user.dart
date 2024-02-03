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

enum Interest { male, female, none }

enum Gender { male, female, other }

class CurUser extends ChangeNotifier {
  Map<String, dynamic>? doc;
  String id = "";
  String newName = "";
  String newAge = "";
  String newNationality = "";
  String newUniversity = "";
  String newEmail = "";
  String newPassword = "";
  String newIdealWeekend = "";
  String newGreenFlags = "";
  String newLifeMovie = "";
  Looking4 newLooking4 = Looking4.none;
  Interest newInterestedIn = Interest.none;
  Gender newGender = Gender.other;
  String newProfilePhotoUrl = "assets/images/default_photo.png";

  Future<bool> downloadUserDoc(WidgetRef ref) async {
    id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) => doc = value.data());

    ref.invalidate(emailProvider);
    ref.invalidate(passwordProvider);

    ref.read(nameProvider.notifier).state = curUser.doc!["name"];
    ref.read(ageProvider.notifier).state = curUser.doc!["age"];
    ref.read(universityProvider.notifier).state = curUser.doc!["university"];
    ref.read(nationalityProvider.notifier).state = curUser.doc!["nationality"];
    ref.read(looking4Provider.notifier).state =
        Looking4.values.byName(curUser.doc!["lookingFor"] ?? "none");
    ref.read(idealWeekendProvider.notifier).state = curUser.doc!["idealWeekend"];
    ref.read(greenFlagsProvider.notifier).state = curUser.doc!["greenFlags"];
    ref.read(lifeMovieProvider.notifier).state = curUser.doc!["lifeMovie"];
    ref.read(interstedInProvider.notifier).state =
        Interest.values.byName(curUser.doc!["interestedIn"] ?? "none");
    ref.read(profilePhotoProvider.notifier).state = curUser.doc!["profile_photo_url"];
    ref.read(genderProvider.notifier).state =
        Gender.values.byName(curUser.doc!["gender"] ?? "other");
    return true;
  }

  void reset(WidgetRef ref) {
    newName = "";
    newAge = "";
    newNationality = "";
    newUniversity = "";
    newEmail = "";
    newPassword = "";
    newIdealWeekend = "";
    newGreenFlags = "";
    newLifeMovie = "";
    doc = null;
    /*
    likedUsers = HashSet<String>();
    dislikedUsers = HashSet<String>();
    matches = HashSet<String>();
    */
    newLooking4 = Looking4.none;
    newInterestedIn = Interest.none;
    newGender = Gender.other;

    newProfilePhotoUrl = "assets/images/default_photo.png";

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
    ref.invalidate(interstedInProvider);
    ref.invalidate(genderProvider);
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
    final curUserId = FirebaseAuth.instance.currentUser!.uid;
    final potentialMatch = await FirebaseFirestore.instance.collection('users').doc(userRef).get();

    HashSet<String> potentialMatchLikes = potentialMatch.data().toString().contains("likedUsers")
        ? HashSet.from(potentialMatch.get("likedUsers"))
        : HashSet<String>();

    if (potentialMatchLikes.contains(curUserId)) {
      final docRef = await Matches(potentialMatch.id, curUserId).createMatch();
      doc!["matches"].add(docRef);
      updateMatches(potentialMatch.id, curUserId, docRef);
      return true;
    }

    return false;
  }

  uploadUserDoc() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(doc!)
        .onError((error, stackTrace) async {
      print("oH OH Error hERE");
      print(error);
    });
  }

  //TODO - Get rid
  void updateMatches(matchedUserId, curUserId, matchRef) async {
    //Better to Query Matches
    await FirebaseFirestore.instance.collection('users').doc(matchedUserId).update({
      'matches': FieldValue.arrayUnion([matchRef]),
    }).onError((error, stackTrace) async {
      print("oH OH Error hERE");
    });

    await FirebaseFirestore.instance.collection('users').doc(curUserId).update({
      'matches': doc!["matches"],
    }).onError((error, stackTrace) async {
      print("oH OH Error hERE");
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
