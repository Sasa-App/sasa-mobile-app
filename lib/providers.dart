import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/models/user.dart';

CurUser curUser = CurUser();

final nameProvider = StateProvider((ref) => curUser.name);
final ageProvider = StateProvider((ref) => curUser.age);
final emailProvider = StateProvider((ref) => curUser.email);
final nationalityProvider = StateProvider((ref) => curUser.nationality);
final universityProvider = StateProvider((ref) => curUser.university);
final profilePhotoProvider = StateProvider((ref) => curUser.profilephotoUrl);
final idealWeekendProvider = StateProvider<String>((ref) => curUser.idealWeekend);
final greenFlagsProvider = StateProvider<String>((ref) => curUser.greenFlags);
final lifeMovieProvider = StateProvider<String>((ref) => curUser.lifeMovie);
final passwordProvider = StateProvider((ref) => curUser.password);
final looking4Provider = StateProvider((ref) => curUser.looking4);

final form1Key = GlobalKey<FormState>();
final form2Key = GlobalKey<FormState>();
final form3Key = GlobalKey<FormState>();
final form5Key = GlobalKey<FormState>();
