import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/providers.dart';

class LetsMeetTheRealYou extends ConsumerWidget {
  const LetsMeetTheRealYou({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's meet the real you...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("Keep your answers as authentic as possible"),
            Form(
              key: form5Key,
              child: Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height * 0.75),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            styledTextFormField(
                                labelText: "Describe your ideal weekend...",
                                ref: ref,
                                inputTextProvider: idealWeekendProvider),
                            styledTextFormField(
                                labelText: "What's your biggest green flag?...",
                                ref: ref,
                                inputTextProvider: greenFlagsProvider),
                            styledTextFormField(
                                labelText:
                                    "If your life was a movie, which one would it be?",
                                ref: ref,
                                inputTextProvider: lifeMovieProvider),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 300,
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
    );
  }
}

Widget styledTextFormField(
    {required String labelText,
    required WidgetRef ref,
    required StateProvider<String> inputTextProvider,
    Widget? suffixIcon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
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
        onChanged: (value) {
          ref.read(inputTextProvider.notifier).state = value;
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter a valid response";
          }
          return null;
        },
      ),
    ],
  );
}
