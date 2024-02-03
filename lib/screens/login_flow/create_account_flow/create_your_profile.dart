import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/data/universities.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:select_dialog/select_dialog.dart';

class CreateYourProfile extends ConsumerWidget {
  CreateYourProfile(this.enteredName, this.enteredAge, this.enteredNationality,
      this.enteredUniversity, this.isEdit,
      {super.key});

  String enteredName;
  String enteredAge;
  String enteredNationality;
  String enteredUniversity;
  bool isEdit;
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
              key: form1Key,
              child: Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height * 0.7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            TextFormField(
                              initialValue: ref.watch(nameProvider),
                              enabled: true,
                              style: const TextStyle(fontSize: 25, color: Colors.red),
                              decoration: const InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter a valid name";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                ref.read(nameProvider.notifier).state = value.trim();
                              },
                            ),
                            const Spacer(),
                            TextFormField(
                              initialValue: ref.watch(ageProvider),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: const TextStyle(fontSize: 25, color: Colors.red),
                              decoration: const InputDecoration(
                                labelText: "Age",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              ),
                              onChanged: (value) {
                                ref.read(ageProvider.notifier).state = value.trim();
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    int.parse(value) < 17 ||
                                    int.parse(value) > 30) {
                                  return "Please enter a valid age";
                                }
                                return null;
                              },
                            ),
                            const Spacer(),
                            const Text(
                              "Gender",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  value: Gender.male,
                                  activeColor: Colors.red,
                                  groupValue: ref.watch(genderProvider),
                                  onChanged: (Gender? value) =>
                                      ref.read(genderProvider.notifier).state = value!,
                                ),
                                Text('Male'),
                                SizedBox(width: 10),
                                Radio(
                                  value: Gender.female,
                                  activeColor: Colors.red,
                                  groupValue: ref.watch(genderProvider),
                                  onChanged: (Gender? value) =>
                                      ref.read(genderProvider.notifier).state = value!,
                                ),
                                Text('Female'),
                                SizedBox(width: 10),
                                Radio(
                                  value: Gender.other,
                                  activeColor: Colors.red,
                                  groupValue: ref.watch(genderProvider),
                                  onChanged: (Gender? value) =>
                                      ref.read(genderProvider.notifier).state = value!,
                                ),
                                Text('Other'),
                              ],
                            ),
                            const Spacer(),
                            TextFormField(
                              style: const TextStyle(fontSize: 25, color: Colors.red),
                              readOnly: true,
                              controller: nationalityController,
                              decoration: const InputDecoration(
                                labelText: "Nationality",
                                labelStyle: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please select your nationality";
                                }
                                return null;
                              },
                            ),
                            const Spacer(),
                            TextFormField(
                              readOnly: true,
                              enabled: !isEdit,

                              controller: universityController,
                              style: const TextStyle(fontSize: 25, color: Colors.red),
                              decoration: InputDecoration(
                                labelText: "University",
                                border: isEdit ? InputBorder.none : null,
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              ),
                              onTap: () {
                                SelectDialog.showModal(context,
                                    label: "Select your University",
                                    items: universities.keys.toList(), onChange: (value) {
                                  universityController.text = value;
                                  ref.read(universityProvider.notifier).state = value.trim();
                                });
                              },
                              onChanged: (value) {
                                ref.read(universityProvider.notifier).state = value;
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please select your university";
                                }
                                return null;
                              },
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
