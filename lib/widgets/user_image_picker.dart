import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required initialPhoto, update});

  Widget? initialPhoto;
  //TODO: make user image picker resusable, either make it a consumerwidget or find another way
  void Function()? update;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;

  void pick() async {
    XFile? pickedImage;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () async {
                      pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 150,
                          imageQuality: 50);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Photo Library",
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () async {
                      pickedImage = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          preferredCameraDevice: CameraDevice.front);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Take photo",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          );
        }).then((value) {
      if (pickedImage == null) {
        return;
      }

      setState(() {
        pickedImageFile = File(pickedImage!.path);
        widget.update;
      });
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
                  : widget.initialPhoto,
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
                  onPressed: pick,
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
