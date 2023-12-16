import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  String? userId1;
  String? userId2;

  Matches(this.userId1, this.userId2);

  Future<String> createMatch() async {
    final docRef = await FirebaseFirestore.instance.collection('matches').doc();

    docRef.set({
      'userId1': userId1,
      'userId2': userId2,
    });

    return docRef.id;
  }
}
