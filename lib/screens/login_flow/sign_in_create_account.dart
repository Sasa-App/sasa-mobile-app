import 'package:flutter/material.dart';

class SignInCreateAccountScreen extends StatefulWidget {
  const SignInCreateAccountScreen({super.key});

  @override
  State<SignInCreateAccountScreen> createState() =>
      _SignInCreateAccountScreenState();
}

class _SignInCreateAccountScreenState extends State<SignInCreateAccountScreen> {
  bool? agreeTerms = false;
  bool? agreeNewsletters = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 30,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Sign in",
              ),
              Tab(
                text: "Create account",
              ),
            ],
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    child: Column(
                      children: [
                        styledTextFormField("Email"),
                        const SizedBox(
                          height: 5,
                        ),
                        styledTextFormField("Password",
                            suffixIcon: const Icon(Icons.remove_red_eye))
                      ],
                    ),
                  ),
                  const Spacer(),
                  CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Transform.translate(
                        offset: const Offset(-20, 7),
                        child: const Text(
                          "Sasa can send me product updates and the occasional newletters",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      value: agreeNewsletters,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          agreeNewsletters = value;
                        });
                      }),
                  CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Transform.translate(
                        offset: const Offset(-20, 7),
                        child: const Text(
                          "I agree to the Terms and Conditions and Privacy Policy",
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      value: agreeTerms,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          agreeTerms = value;
                        });
                      }),
                  OutlinedButton(
                    onPressed: () {
                      print("Here");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignInCreateAccountScreen();
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
          ),
          Placeholder(),
        ]),
      ),
    );
  }
}

Widget styledTextFormField(String labelText, {Widget? suffixIcon}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey.shade200,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      suffixIcon: suffixIcon,
    ),
  );
}
