import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sasa_mobile_app/models/profile_details.dart';
import 'package:sasa_mobile_app/screens/feed.dart';
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

final firebase = FirebaseAuth.instance;

class CreateAccount extends ConsumerWidget {
  CreateAccount({super.key});

  int currentIndex = 0;

  bool isVisible = false;
  bool isDisableGesture = false;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void submit() async {
      newUser.enteredEmail =
          "${ref.read(emailProvider.notifier).state}${universities[ref.watch(universityProvider)]}";
      newUser.enteredPassword = ref.read(passwordProvider.notifier).state;
      newUser.enteredName = ref.read(nameProvider.notifier).state;
      newUser.enteredAge = ref.read(ageProvider.notifier).state;
      newUser.enteredUniversity = ref.read(universityProvider.notifier).state;
      newUser.enteredNationality = ref.read(nationalityProvider.notifier).state;
      newUser.looking4 = ref.read(looking4Provider.notifier).state;
      newUser.idealWeekend = ref.read(idealWeekendProvider.notifier).state;
      newUser.greenFlags = ref.read(greenFlagsProvider.notifier).state;
      newUser.lifeMovie = ref.read(lifeMovieProvider.notifier).state;

      try {
        final userCredentials = await firebase.createUserWithEmailAndPassword(
            email: newUser.enteredEmail, password: newUser.enteredPassword);
        print(userCredentials);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
      }
    }

    final screens = [
      CreateYourProfile(newUser.enteredName, newUser.enteredAge,
          newUser.enteredNationality, newUser.enteredUniversity),
      SecurityVerification(newUser.enteredEmail, newUser.enteredPassword),
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
          children: [
            Expanded(
              child: CarouselSlider(
                items: screens,
                disableGesture: false,
                carouselController: carouselController,
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: double.infinity,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    if ((currentIndex == 0 &&
                            !form1Key.currentState!.validate()) ||
                        (currentIndex == 1 &&
                            !form2Key.currentState!.validate()) ||
                        (currentIndex == 2 &&
                            ref.watch(profilePhotoProvider) ==
                                "assets/images/default_photo.png") ||
                        (currentIndex == 3 &&
                            ref.watch(looking4Provider) == Looking4.none) ||
                        (currentIndex == 4 &&
                            !form5Key.currentState!.validate())) {
                      carouselController.animateToPage(currentIndex);

                      if (currentIndex == 2) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please to select a valid profile photo'),
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
              submit();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const FeedScreen();
              }));
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
