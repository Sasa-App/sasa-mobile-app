import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  var enteredEmail = "";
  var enteredPassword = "";

  bool? agreeTerms = false;
  bool? agreeNewsletters = false;
  bool obscureText = true;

  late TabController _tabController;

  final formKey = GlobalKey<FormState>();

  void submit() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    formKey.currentState!.save();

    try {
      final userCredentials = await firebase
          .signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword)
          .then((value) {
        if (!value.user!.emailVerified) {
          value.user?.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Please check your inbox to verify your email. Ensure to check your junk/spam!'),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
      }

      return;
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            if (index == 1) {
              _tabController.animateTo(0);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateEditAccount();
              }));
            }
          },
          tabs: const [
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      styledTextFormField(
                        "Email",
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        onSaved: (value) {
                          enteredEmail = value!;
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      styledTextFormField(
                        "Password",
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.remove_red_eye,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        obscureText: obscureText,
                        onSaved: (value) {
                          enteredPassword = value!;
                        },
                      )
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
                    submit();
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
    );
  }
}

Widget styledTextFormField(String labelText,
    {Widget? suffixIcon,
    TextInputType? keyboardType,
    required bool obscureText,
    required void Function(String?)? onSaved}) {
  return TextFormField(
    keyboardType: keyboardType,
    autocorrect: false,
    textCapitalization: TextCapitalization.none,
    obscureText: obscureText,
    validator: (value) {
      if (value == "") {
        return "Please enter a valid input";
      }

      return null;
    },
    onSaved: onSaved,
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
