import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/create_account.dart';
import 'package:sasa_mobile_app/models/profile_details.dart';

ProfileDetails newUser = ProfileDetails();

final nameProvider = StateProvider((ref) => newUser.enteredName);
final ageProvider = StateProvider((ref) => newUser.enteredAge);
final emailProvider = StateProvider((ref) => newUser.enteredEmail);
final nationalityProvider = StateProvider((ref) => newUser.enteredNationality);
final universityProvider = StateProvider((ref) => newUser.enteredUniversity);
