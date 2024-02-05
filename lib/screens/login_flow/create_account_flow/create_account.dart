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
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/interested_in.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/security_verification.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/select_a_profile_photo.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/your_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'dart:io';

final firebase = FirebaseAuth.instance;

class CreateEditAccount extends ConsumerWidget {
  CreateEditAccount({super.key, this.isEdit = false});

  int currentIndex = 0;

  bool isVisible = false;
  bool isEdit;
  bool isDisableGesture = false;
  final CarouselController carouselController = CarouselController();
  bool isSubmmitting = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> submit() async {
      curUser.newEmail =
          "${ref.read(emailProvider.notifier).state}${universities[ref.watch(universityProvider)]}";
      curUser.newPassword = ref.read(passwordProvider.notifier).state;
      curUser.newName = ref.read(nameProvider.notifier).state;
      curUser.newAge = ref.read(ageProvider.notifier).state;
      curUser.newUniversity = ref.read(universityProvider.notifier).state;
      curUser.newNationality = ref.read(nationalityProvider.notifier).state;
      curUser.newLooking4 = ref.read(looking4Provider.notifier).state;
      curUser.newIdealWeekend = ref.read(idealWeekendProvider.notifier).state;
      curUser.newGreenFlags = ref.read(greenFlagsProvider.notifier).state;
      curUser.newLifeMovie = ref.read(lifeMovieProvider.notifier).state;
      curUser.newInterestedIn = ref.read(interstedInProvider.notifier).state;
      curUser.newGender = ref.read(genderProvider.notifier).state;

      if (isEdit) {
        curUser.doc!["name"] = curUser.newName;
        curUser.doc!["age"] = curUser.newAge;
        curUser.doc!["university"] = curUser.newUniversity;
        curUser.doc!["nationality"] = curUser.newNationality;
        curUser.doc!["lookingFor"] = curUser.newLooking4.name.toString();
        curUser.doc!["idealWeekend"] = curUser.newIdealWeekend;
        curUser.doc!["greenFlags"] = curUser.newGreenFlags;
        curUser.doc!["lifeMovie"] = curUser.newLifeMovie;
        curUser.doc!["interestedIn"] = curUser.newInterestedIn.name.toString();
        curUser.doc!["gender"] = curUser.newGender.name.toString();

        final storageRef =
            FirebaseStorage.instance.ref().child('user_profile_photo').child('${curUser.id}.jpg');

        if (!ref.read(profilePhotoProvider.notifier).state.contains("firebasestorage")) {
          await storageRef.putFile(File(ref.read(profilePhotoProvider.notifier).state));
          curUser.newProfilePhotoUrl = await storageRef.getDownloadURL();
          curUser.doc!["profile_photo_url"] = curUser.newProfilePhotoUrl;
        } else {
          curUser.doc!["profile_photo_url"] = ref.read(profilePhotoProvider.notifier).state;
        }

        await curUser.uploadUserDoc();
      } else {
        try {
          final UserCredential userCredentials = await firebase.createUserWithEmailAndPassword(
              email: curUser.newEmail, password: curUser.newPassword);

          try {
            await userCredentials.user?.sendEmailVerification();
          } catch (e) {
            print("An error occured while trying to send email        verification");
            print(e.toString());
            return false;
          }

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('user_profile_photo')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(File(ref.read(profilePhotoProvider.notifier).state));
          curUser.newProfilePhotoUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
            'name': curUser.newName,
            'age': curUser.newAge,
            'nationality': curUser.newNationality,
            'university': curUser.newUniversity,
            'email': curUser.newEmail,
            'profile_photo_url': curUser.newProfilePhotoUrl,
            'interestedIn': curUser.newInterestedIn.name.toString(),
            'lookingFor': curUser.newLooking4.name.toString(),
            'idealWeekend': curUser.newIdealWeekend,
            'greenFlags': curUser.newGreenFlags,
            'lifeMovie': curUser.newLifeMovie,
            'likedUsers': [],
            'dislikedUsers': [],
            'matches': [],
            'seenUsers': [],
            'gender': curUser.newGender.name.toString(),
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
      }

      return true;
    }

    final screens = [
      CreateYourProfile(
          curUser.newName, curUser.newAge, curUser.newNationality, curUser.newUniversity, isEdit),
      if (!isEdit) ...[
        SecurityVerification(curUser.newEmail, curUser.newPassword),
      ],
      SelectAProfilePhoto(),
      InterestedIn(),
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
              if (curUser.doc == null) {
                curUser.reset(ref);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.red,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: !isSubmmitting
            ? Column(
                mainAxisSize: MainAxisSize.max,
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
                        FocusScope.of(context).unfocus();
                        if ((currentIndex == 0 && !form1Key.currentState!.validate()) ||
                            (currentIndex == 1 && !isEdit && !form2Key.currentState!.validate()) ||
                            (((isEdit && currentIndex == 1) || (!isEdit && currentIndex == 2)) &&
                                ref.watch(profilePhotoProvider) ==
                                    "assets/images/default_photo.png") ||
                            (((isEdit && currentIndex == 2) || (!isEdit && currentIndex == 3)) &&
                                ref.watch(interstedInProvider) == Interest.none) ||
                            (((isEdit && currentIndex == 3) || (!isEdit && currentIndex == 4)) &&
                                ref.watch(looking4Provider) == Looking4.none) ||
                            (((isEdit && currentIndex == 4) || (!isEdit && currentIndex == 5)) &&
                                !form5Key.currentState!.validate())) {
                          carouselController.animateToPage(currentIndex);

                          if ((isEdit && currentIndex == 1) || (!isEdit && currentIndex == 2)) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please to select a valid profile photo'),
                              ),
                            );
                          }

                          if ((isEdit && currentIndex == 2) || (!isEdit && currentIndex == 3)) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please to select a valid option'),
                              ),
                            );
                          }
                          return;
                        } else {
                          /*
                          if (currentIndex == 0 && isEdit) {
                            carouselController.animateToPage(2);
                          }*/
                        }

                        setState(() {
                          currentIndex = index;

                          print(currentIndex);
                          if ((isEdit && currentIndex == 5) || (!isEdit && currentIndex == 6)) {
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
                  const Expanded(
                    child: SizedBox(
                      height: 50,
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Visibility(
          visible: isVisible,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                isSubmmitting = true;
                submit().then((successful) {
                  if (successful) {
                    //await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    if (isEdit) {
                      Navigator.pop(context, "Changes saved!");
                      /*
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text("Changes Saved!"),
                        ),
                      ).then((value) {
                        Navigator.pop(context, "Changes saved!");
                      });*/
                    } else {
                      curUser.reset(ref);
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text("One last thing!"),
                          content: Text(
                              "We've just sent you an email for verification. Please verify to enable login"),
                        ),
                      ).then((value) => Navigator.pop(context));
                    }

                    /*
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));*/
                  }
                });
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
