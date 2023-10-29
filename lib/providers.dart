import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/models/profile_details.dart';

ProfileDetails newUser = ProfileDetails();

final nameProvider = StateProvider((ref) => newUser.enteredName);
final ageProvider = StateProvider((ref) => newUser.enteredAge);
final emailProvider = StateProvider((ref) => newUser.enteredEmail);
final nationalityProvider = StateProvider((ref) => newUser.enteredNationality);
final universityProvider = StateProvider((ref) => newUser.enteredUniversity);
final profilePhotoProvider =
    StateProvider((ref) => "assets/images/default_photo.png");
final idealWeekendProvider =
    StateProvider<String>((ref) => newUser.idealWeekend);
final greenFlagsProvider = StateProvider<String>((ref) => newUser.greenFlags);
final lifeMovieProvider = StateProvider<String>((ref) => newUser.lifeMovie);
final passwordProvider = StateProvider((ref) => newUser.enteredPassword);
final looking4Provider = StateProvider((ref) => newUser.looking4);
final form1Key = GlobalKey<FormState>();
final form2Key = GlobalKey<FormState>();
final form3Key = GlobalKey<FormState>();
final form5Key = GlobalKey<FormState>();
