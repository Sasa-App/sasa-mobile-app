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

enum Interest { men, women, none }

class CurUser {
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
  String newProfilePhotoUrl = "assets/images/default_photo.png";

  Future<bool> downloadUserDoc(WidgetRef ref) async {
    id = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) => doc = value.data());

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

  void uploadUserDoc() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(doc!)
        .onError((error, stackTrace) async {
      print("oH OH Erro hERE");
    });
  }

  //TODO - Get rid
  void updateMatches(matchedUserId, curUserId, matchRef) async {
    //Better to Query Matches
    await FirebaseFirestore.instance.collection('users').doc(matchedUserId).update({
      'matches': FieldValue.arrayUnion([matchRef]),
    }).onError((error, stackTrace) async {
      print("oH OH Erro hERE");
    });

    await FirebaseFirestore.instance.collection('users').doc(curUserId).update({
      'matches': doc!["matches"],
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
