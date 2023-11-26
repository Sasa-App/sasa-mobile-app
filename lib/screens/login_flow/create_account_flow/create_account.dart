import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:sasa_mobile_app/screens/feed.dart';
import 'package:sasa_mobile_app/screens/home.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/create_your_profile.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/lets_meet_the_real_you.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/looking_for.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/security_verification.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/select_a_profile_photo.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/your_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'dart:io';

final firebase = FirebaseAuth.instance;

class CreateAccount extends ConsumerWidget {
  CreateAccount({super.key});

  int currentIndex = 0;

  bool isVisible = false;
  bool isDisableGesture = false;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> submit() async {
      curUser.email =
          "${ref.read(emailProvider.notifier).state}${universities[ref.watch(universityProvider)]}";
      curUser.password = ref.read(passwordProvider.notifier).state;
      curUser.name = ref.read(nameProvider.notifier).state;
      curUser.age = ref.read(ageProvider.notifier).state;
      curUser.university = ref.read(universityProvider.notifier).state;
      curUser.nationality = ref.read(nationalityProvider.notifier).state;
      curUser.looking4 = ref.read(looking4Provider.notifier).state;
      curUser.idealWeekend = ref.read(idealWeekendProvider.notifier).state;
      curUser.greenFlags = ref.read(greenFlagsProvider.notifier).state;
      curUser.lifeMovie = ref.read(lifeMovieProvider.notifier).state;

      try {
        final userCredentials = await firebase.createUserWithEmailAndPassword(
            email: curUser.email, password: curUser.password);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_photo')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(File(ref.read(profilePhotoProvider.notifier).state));
        curUser.profilephotoUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
          'name': curUser.name,
          'age': curUser.age,
          'nationality': curUser.nationality,
          'university': curUser.university,
          'email': curUser.email,
          'profile_photo_url': curUser.profilephotoUrl,
          'lookingFor': curUser.looking4.toString(),
          'idealWeekend': curUser.idealWeekend,
          'greenFlags': curUser.greenFlags,
          'lifeMovie': curUser.lifeMovie
        }).onError((error, stackTrace) async {
          await storageRef.delete();
        });
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
        return false;
      }
      return true;
    }

    final screens = [
      CreateYourProfile(curUser.name, curUser.age, curUser.nationality, curUser.university),
      SecurityVerification(curUser.email, curUser.password),
      SelectAProfilePhoto(),
      LookingFor(),
      LetsMeetTheRealYou(),
      YourProfile(),
    ];

    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.red,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider(
              items: screens,
              disableGesture: false,
              carouselController: carouselController,
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height * 0.8,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  if ((currentIndex == 0 && !form1Key.currentState!.validate()) ||
                      (currentIndex == 1 && !form2Key.currentState!.validate()) ||
                      (currentIndex == 2 &&
                          ref.watch(profilePhotoProvider) == "assets/images/default_photo.png") ||
                      (currentIndex == 3 && ref.watch(looking4Provider) == Looking4.none) ||
                      (currentIndex == 4 && !form5Key.currentState!.validate())) {
                    carouselController.animateToPage(currentIndex);

                    if (currentIndex == 2) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please to select a valid profile photo'),
                        ),
                      );
                    }

                    if (currentIndex == 3) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please to select a valid option'),
                        ),
                      );
                    }
                    return;
                  }

                  setState(() {
                    currentIndex = index;
                    print(currentIndex);
                    if (currentIndex == 5) {
                      isVisible = true;
                    } else {
                      isVisible = false;
                    }
                  });
                },
              ),
            ),
            DotsIndicator(
              dotsCount: screens.length,
              position: currentIndex,
              decorator: const DotsDecorator(activeColor: Colors.red),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Visibility(
          visible: isVisible,
          child: FloatingActionButton(
            onPressed: () { 
              submit().then((successful) {
                if (successful) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                }
              });
              
            },
            //mini: true,
            backgroundColor: Colors.red,
            child: const Icon(Icons.upload),
          ),
        ),
      );
    });
  }
}
