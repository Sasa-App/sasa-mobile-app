import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'package:sasa_mobile_app/providers.dart';

class SecurityVerification extends ConsumerWidget {
  SecurityVerification(this.enteredEmail, this.enteredPassword, {super.key});

  String enteredEmail;
  String enteredPassword;
  bool obscureText = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Security verification",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text("We need these details to confirm your identity."),
            Form(
              key: form2Key,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      enabled: false,
                      initialValue: ref.watch(universityProvider),
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                      decoration: const InputDecoration(
                        labelText: "University",
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                    ),
                    TextFormField(
                      initialValue: ref.read(emailProvider.notifier).state,
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                      decoration: InputDecoration(
                        labelText: "University email",
                        suffixText: universities[ref.watch(universityProvider)],
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.contains("@")) {
                          return "Please enter a valid student email";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ref.read(emailProvider.notifier).state = value.trim();
                        print(ref.read(emailProvider.notifier).state);
                      },
                    ),
                    Column(
                      children: [
                        TextFormField(
                          style:
                              const TextStyle(fontSize: 25, color: Colors.red),
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            isCollapsed: true,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StatefulBuilder(builder: (context, setState) {
                          return TextFormField(
                            //inputFormatters: [maskFormatter],
                            initialValue: ref.watch(passwordProvider),
                            obscureText: obscureText,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              isCollapsed: true,
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                              contentPadding: const EdgeInsets.all(12),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter a valid password";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              ref.read(passwordProvider.notifier).state = value;
                            },
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
