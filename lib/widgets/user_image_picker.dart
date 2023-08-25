import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 150, imageQuality: 50);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: pickedImageFile != null
                  ? Image(
                      image: FileImage(pickedImageFile!),
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade100,
                height: 35,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: pickImage,
                  icon: const Icon(Icons.keyboard_control),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
