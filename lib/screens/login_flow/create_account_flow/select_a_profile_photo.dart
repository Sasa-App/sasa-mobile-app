import 'package:flutter/material.dart';

Widget selectAProfilePhoto() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select a profile photo",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text("Be sure to choose your best one!"),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text(
                    "Upload",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade100,
                height: 35,
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.keyboard_control)),
              )
            ],
          ),
        ]),
  );
}
