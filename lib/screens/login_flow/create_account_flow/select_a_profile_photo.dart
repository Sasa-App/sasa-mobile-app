import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/widgets/user_image_picker.dart';

class SelectAProfilePhoto extends StatefulWidget {
  const SelectAProfilePhoto({super.key});

  @override
  State<SelectAProfilePhoto> createState() => _SelectAProfilePhotoState();
}

class _SelectAProfilePhotoState extends State<SelectAProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a profile photo",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text("Be sure to choose your best one!"),
            UserImagePicker(),
          ]),
    );
    ;
  }
}

/** 
Widget selectAProfilePhoto() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a profile photo",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text("Be sure to choose your best one!"),
          UserImagePicker(),
        ]),
  );
}
*/