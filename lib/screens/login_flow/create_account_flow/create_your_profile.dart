import 'package:flutter/material.dart';

Widget createYourProfile(GlobalKey formKey, String enteredName,
    String enteredAge, String enteredNationality, String enteredUniversity) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create your profile",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text("You can modify these later."),
          Form(
            key: formKey,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    initialValue: enteredName,
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    ),
                    onChanged: (value) {
                      enteredName = value;
                    },
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 25, color: Colors.red),
                    decoration: const InputDecoration(
                      labelText: "Age",
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
                      labelText: "Nationality",
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
                      labelText: "University",
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
