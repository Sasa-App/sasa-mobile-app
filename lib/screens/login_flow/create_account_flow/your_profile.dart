import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sasa_mobile_app/widgets/profile_card.dart';

class YourProfile extends ConsumerWidget {
  YourProfile({super.key});

  int currentIndex = 0;
  bool isVisible = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return profileCard(ref, false, MediaQuery.of(context).size.height);
  }
}
