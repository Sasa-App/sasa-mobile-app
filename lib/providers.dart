import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CurUser curUser = CurUser();

final nameProvider = StateProvider((ref) => curUser.newName);
final ageProvider = StateProvider((ref) => curUser.newAge);
final emailProvider = StateProvider((ref) => curUser.newEmail);
final nationalityProvider = StateProvider((ref) => curUser.newNationality);
final universityProvider = StateProvider((ref) => curUser.newUniversity);
final profilePhotoProvider = StateProvider((ref) => curUser.newProfilePhotoUrl);
final idealWeekendProvider = StateProvider<String>((ref) => curUser.newIdealWeekend);
final greenFlagsProvider = StateProvider<String>((ref) => curUser.newGreenFlags);
final lifeMovieProvider = StateProvider<String>((ref) => curUser.newLifeMovie);
final passwordProvider = StateProvider((ref) => curUser.newPassword);
final looking4Provider = StateProvider((ref) => curUser.newLooking4);
final interstedInProvider = StateProvider((ref) => curUser.newInterestedIn);


final form1Key = GlobalKey<FormState>();
final form2Key = GlobalKey<FormState>();
final form3Key = GlobalKey<FormState>();
final form5Key = GlobalKey<FormState>();




