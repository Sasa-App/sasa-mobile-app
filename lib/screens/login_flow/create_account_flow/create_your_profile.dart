import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:country_picker/country_picker.dart';

class CreateYourProfile extends ConsumerWidget {
  CreateYourProfile(this.enteredName, this.enteredAge, this.enteredNationality,
      this.enteredUniversity,
      {super.key});

  String enteredName;
  String enteredAge;
  String enteredNationality;
  String enteredUniversity;
  var nationality = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      initialValue: ref.read(nameProvider.notifier).state,
                      enabled: true,
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
                        ref.read(nameProvider.notifier).state = value;
                      },
                    ),
                    TextFormField(
                      initialValue: ref.read(ageProvider.notifier).state,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      onChanged: (value) {
                        ref.read(ageProvider.notifier).state = value;
                      },
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 25, color: Colors.red),
                      readOnly: true,
                      controller: nationality,
                      decoration: const InputDecoration(
                        labelText: "Nationality",
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      ),
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryFilter: <String>[
                              'DZ',
                              'AO',
                              'BJ',
                              'BW',
                              'BF',
                              'BI',
                              'CM',
                              'CV',
                              'CF',
                              'TD',
                              'KM',
                              'AO',
                              'CD',
                              'CI',
                              'DJ',
                              'EG',
                              'GQ',
                              'ER',
                              'SZ',
                              'ET',
                              'GA',
                              'GM',
                              'GH',
                              'GN',
                              'GW',
                              'KE',
                              'LS',
                              'LR',
                              'MG',
                              'MW',
                              'ML',
                              'MR',
                              'MU',
                              'YT',
                              'MA',
                              'MZ',
                              'NA',
                              'NE',
                              'NG',
                              'RE',
                              'RW',
                              'SH',
                              'ST',
                              'SN',
                              'SC',
                              'SL',
                              'SO',
                              'ZA',
                              'SS',
                              'SD',
                              'TZ',
                              'TG',
                              'TN',
                              'UG',
                              'EH',
                              'ZM',
                              'ZW',
                            ],
                            onSelect: (Country country) {
                              nationality.text =
                                  "${country.flagEmoji} ${country.name}";
                              ref.read(nationalityProvider.notifier).state =
                                  "${country.flagEmoji} ${country.name}";
                            });
                      },
                      onChanged: (value) {
                        ref.read(nationalityProvider.notifier).state = value;
                      },
                    ),
                    TextFormField(
                        initialValue:
                            ref.read(universityProvider.notifier).state,
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
                        onTap: () {
                          //TODO: Make the list of universities selectable
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: ListView(
                                        children: universities.keys
                                            .map((value) =>
                                                ListTile(title: Text(value)))
                                            .toList()),
                                  ));
                        },
                        onChanged: (value) {
                          ref.read(universityProvider.notifier).state = value;
                        }),
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
*/