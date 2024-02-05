import 'package:flutter/material.dart';
import 'package:sasa_mobile_app/models/user.dart';
import 'package:sasa_mobile_app/screens/login_flow/create_account_flow/create_account.dart';
import 'package:sasa_mobile_app/widgets/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/providers.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<Profile> {
  @override
  Widget build(context) {
    //print(ref.watch(profilePhotoProvider));

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                color: Colors.red,
                icon: const Icon(
                  Icons.edit,
                  size: 30,
                ),
                onPressed: () {
                  //curUser.newEmail =
                  //   "${ref.read(emailProvider.notifier).state}${universities[ref.watch(universityProvider)]}";
                  //ref.read(passwordProvider.notifier).state;
                  /*
                  final result = Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CreateEditAccount(
                      isEdit: true,
                    );
                  })).then((value) => setState(() {}));*/
                  _navigateToEditAcountScreen(context);
                },
              ),
              Spacer(),
              IconButton(
                color: Colors.red,
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) => curUser.reset(ref));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ]),
        body: profileCard(ref, MediaQuery.of(context).size.height, isDisplayedonFeed: false));
  }

  // A method that launches the SelectionScreen and awaits the result from
// Navigator.pop.
  Future<void> _navigateToEditAcountScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateEditAccount(
                isEdit: true,
              )),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    setState(() {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    });
   
  }
}
