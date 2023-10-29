import 'package:flutter/material.dart';

enum Looking4 { flirting, frienship, none }

class ProfileDetails extends ChangeNotifier {
  String enteredName = "";
  String enteredAge = "";
  String enteredNationality = "";
  String enteredUniversity = "";
  String enteredEmail = "";
  String enteredPassword = "";
  String idealWeekend = "";
  String greenFlags = "";
  String lifeMovie = "";
  Looking4 looking4 = Looking4.none;

  ProfileDetails();
}
