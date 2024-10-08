import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UserImagePicker extends ConsumerWidget {
  UserImagePicker({super.key, required this.initialPhotoProvider, update});

  final StateProvider<String> initialPhotoProvider;
  void Function()? update;

  File? pickedImageFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          //maxWidth: 150,
                          imageQuality: 100);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Photo Library",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
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
          }).then((value) async {
        if (pickedImage == null) {
          return;
        }

        /*
        ImageProperties props =
            await FlutterNativeImage.getImageProperties(pickedImage!.path);

        int newWidth = 0, newHeight = 0;
        if (props.width! < props.height!) {
          double scaleFactor = props.height! / 400.0;
          newWidth = (props.width!.toDouble() / scaleFactor).toInt();
          newHeight = 400;
        } else {
          double scaleFactor = props.width! / 400.0;
          newWidth = 400;
          newHeight = (props.height!.toDouble() / scaleFactor).toInt();
        }

        File resizedFile = await FlutterNativeImage.compressImage(
            pickedImage!.path,
            quality: 100,
            targetWidth: newWidth,
            targetHeight: newHeight);

        pickedImageFile = resizedFile;
        */

        pickedImageFile = File(pickedImage!.path);
        ref.read(initialPhotoProvider.notifier).state = pickedImage!.path;
      });
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: Image(
                image: ref.watch(initialPhotoProvider) !=
                        "assets/images/default_photo.png"
                    ? !ref.watch(initialPhotoProvider).contains("firebasestorage")
                        ? FileImage(File(ref.watch(initialPhotoProvider)))
                        : Image.network(curUser.doc!["profile_photo_url"]).image
                    : AssetImage(ref.watch(initialPhotoProvider)),
                   
                fit: BoxFit.fitWidth,
              ),
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
