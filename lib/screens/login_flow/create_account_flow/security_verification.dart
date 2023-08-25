import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
