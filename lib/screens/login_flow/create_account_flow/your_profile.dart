import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';

class YourProfile extends ConsumerWidget {
  YourProfile({super.key});

  int currentIndex = 0;
  bool isVisible = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screens = [
      styledTextFormField(
          labelText: "Describe your ideal weekend...",
          ref: ref,
          inputTextProvider: idealWeekendProvider),
      styledTextFormField(
          labelText: "What's your biggest green flag?...",
          ref: ref,
          inputTextProvider: greenFlagsProvider),
      styledTextFormField(
          labelText: "If your life was a movie, which one would it be?",
          ref: ref,
          inputTextProvider: lifeMovieProvider),
    ];

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Profile...",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Image(
                        image: ref.watch(profilePhotoProvider) !=
                                "assets/images/default_photo.png"
                            ? FileImage(File(ref.watch(profilePhotoProvider)))
                            : AssetImage(ref.watch(profilePhotoProvider))
                                as ImageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Text(ref.watch(nameProvider),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    "🎂 ${ref.watch(ageProvider)}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ref.watch(nationalityProvider),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ref.watch(universityProvider),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.red,
                    thickness: 1,
                  ),
                ]),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        CarouselSlider(
          items: screens,
          options: CarouselOptions(
              enableInfiniteScroll: true,
              viewportFraction: 1,
              aspectRatio: 16 / 7),
        ),
      ],
    );
  }
}

Widget styledTextFormField(
    {required String labelText,
    required WidgetRef ref,
    required StateProvider<String> inputTextProvider,
    Widget? suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelText,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 4,
          initialValue: ref.watch(inputTextProvider),
          decoration: InputDecoration(
            filled: true,
            enabled: false,
            fillColor: Colors.grey.shade200,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    ),
  );
}
