import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';

Widget profileCard(
  WidgetRef ref,
  bool isDisplayedonFeed,
  double screenHeight,
    {Map<String, dynamic>? userProfile,
    void Function()? likeFunction,
  void Function()? dislikeFunction,
}) {
  final screens = [
    styledTextFormField(
      labelText: "Describe your ideal weekend...",
      inputText: userProfile?["idealWeekend"] ?? ref.watch(idealWeekendProvider),
    ),
    styledTextFormField(
      labelText: "What's your biggest green flag?...",
      inputText: userProfile?["greenFlags"] ?? ref.watch(greenFlagsProvider),
    ),
    styledTextFormField(
      labelText: "If your life was a movie, which one would it be?",
      inputText: userProfile?["lifeMovie"] ?? ref.watch(lifeMovieProvider),
    ),
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
                if (!isDisplayedonFeed)
                  const Text(
                    "Your Profile...",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 1 / 4 * screenHeight,
                        width: double.infinity,
                        child: Image(
                          image:
                              userProfile != null
                              ? Image.network(userProfile["profile_photo_url"] ??
                                      curUser.doc!["profile_photo_url"])
                                  .image
                              : curUser.newProfilePhotoUrl == "assets/images/default_photo.png"
                                  ? FileImage(File(ref.watch(profilePhotoProvider)))
                                      as ImageProvider
                                  : AssetImage(
                                      ref.watch(profilePhotoProvider),
                                    ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    if (isDisplayedonFeed) ...[
                      Positioned(
                          right: -15,
                          bottom: -15,
                          child: GestureDetector(
                            onTap: () {
                              likeFunction!();
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child: Text(
                                userProfile?["looking4"] == "Looking4.aGoodTime" ? "🔥" : "💗",
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          )),
                      Positioned(
                          left: -15,
                          bottom: 1 / 11 * screenHeight,
                          child: GestureDetector(
                            onTap: () {
                              dislikeFunction!();
                            },
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ))
                    ]
                  ],
                ),
                Text(userProfile?["name"] ?? ref.watch(nameProvider),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  "🎂 ${userProfile?["age"] ?? ref.watch(ageProvider)}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  userProfile?["nationality"] ?? ref.watch(nationalityProvider),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  userProfile?["university"] ?? ref.watch(universityProvider),
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
        options:
            CarouselOptions(
          height: 1 / 4.5 * screenHeight,
          enableInfiniteScroll: true,
          viewportFraction: 1,
        ),
      ),
    ],
  );
}

Widget styledTextFormField(
    {required String labelText, required String inputText, Widget? suffixIcon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelText,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 4,
          readOnly: true,
          initialValue: inputText,
          decoration: InputDecoration(
            filled: true,
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
