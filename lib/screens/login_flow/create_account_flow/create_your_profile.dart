import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:select_dialog/select_dialog.dart';

class CreateYourProfile extends ConsumerWidget {
  CreateYourProfile(this.enteredName, this.enteredAge, this.enteredNationality,
      this.enteredUniversity,
      {super.key});

  String enteredName;
  String enteredAge;
  String enteredNationality;
  String enteredUniversity;
  var nationalityController = TextEditingController();
  var universityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    nationalityController.text = ref.watch(nationalityProvider);
    universityController.text = ref.watch(universityProvider);
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
                      controller: nationalityController,
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
                            countryListTheme: CountryListThemeData(),
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
                              nationalityController.text =
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
                        readOnly: true,
                        controller: universityController,
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
                          SelectDialog.showModal(context,
                              label: "Select your University",
                              items: universities.keys.toList(),
                              onChange: (value) {
                            universityController.text = value;
                            ref.read(universityProvider.notifier).state = value;
                          });
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
