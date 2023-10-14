import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityVerification extends ConsumerWidget {
  SecurityVerification(this.enteredEmail, this.enteredPassword, {super.key});

  String enteredEmail;
  String enteredPassword;
  bool obscureText = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '#-#-#-#-#-#-#',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

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
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                      decoration: const InputDecoration(
                        labelText: "University email",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
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

/** 
Widget securityVerification(String enteredUniversity, String enteredEmail) {
  var maskFormatter = MaskTextInputFormatter(
      mask: '#-#-#-#-#-#-#',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                    decoration: const InputDecoration(
                      labelText: "University",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                    decoration: const InputDecoration(
                      labelText: "University email",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                  ),
                  Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 25, color: Colors.red),
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: "Verification code",
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
                      TextFormField(
                        inputFormatters: [maskFormatter],
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            isCollapsed: true,
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                            contentPadding: EdgeInsets.all(12),
                            suffixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: Colors.red,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
  );
}
*/