import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

final firebase = FirebaseAuth.instance;

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  int currentIndex = 0;

  bool isVisible = false;

  final formKey = GlobalKey<FormState>();

  void submit() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    formKey.currentState!.save();

    try {
      final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: newUser.enteredEmail, password: newUser.enteredPassword);
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      CreateYourProfile(newUser.enteredName, newUser.enteredAge,
          newUser.enteredNationality, newUser.enteredUniversity),
      SecurityVerification(newUser.enteredEmail, newUser.enteredPassword),
      SelectAProfilePhoto(),
      LookingFor(),
      LetsMeetTheRealYou(),
      YourProfile(),
    ];

    return Scaffold(
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
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
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
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          onPressed: () {
            submit();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FeedScreen();
            }));
          },
          mini: true,
          backgroundColor: Colors.red,
          child: const Icon(Icons.person_add_outlined),
        ),
      ),
    );
  }
}
