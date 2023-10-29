import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/widgets/user_image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectAProfilePhoto extends ConsumerWidget {
  const SelectAProfilePhoto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool validator() {
      return true;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a profile photo",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("Be sure to choose your best one!"),
            Form(
                key: form3Key,
                child: Form(
                  child: UserImagePicker(
                      initialPhotoProvider: profilePhotoProvider),
                )),
          ]),
    );
    ;
  }
}
