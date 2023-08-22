import 'package:flutter/material.dart';

Widget securityVerification() {
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
                  TextFormField(
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                    decoration: const InputDecoration(
                      labelText: "Veification code",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
  );
}
