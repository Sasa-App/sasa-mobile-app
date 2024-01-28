import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/chat.dart';
import 'package:sasa_mobile_app/screens/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sasa_mobile_app/widgets/profile_card.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class FeedScreen extends ConsumerStatefulWidget {
  FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  //HashSet<String> feed = feedSnapshots.toSet();
  //late Set<QueryDocumentSnapshot<Map<String, dynamic>?>> feedSnapshots;
  Stream<QuerySnapshot<Map<String, dynamic>>> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  //QuerySnapshot<Map<String, dynamic>> firstBatch = await FirebaseFirestore.instance.collection('users').snapshots().first;

  //String curProfileId =

  String? nextProfileId;
  String? curProfileId;

  List<String> visitedUsers = [];

  late PageController feedSwiper = PageController(keepPage: true);
  var currentPage = 0;
  bool pageChanged = false;
  bool isReachedEnd = false;

  @override
  void initState() {
    curUser.downloadUserDoc(ref);

    /*
    getFeed() async {
      currentPage = await curUser.getCurPage().then((value) => value.toInt());
      feedSwiper = PageController(initialPage: currentPage.toInt(), keepPage: true);
    }

    getFeed();
    */

    //feedSwiper = PageController(keepPage: true);
/*
    users.listen((querySnapshot) {
      //users.removeAll
      querySnapshot.docChanges.where((change) {
        return change.type == DocumentChangeType.removed;
      });
    }).onData((data) {
      if (curUser.doc?["lastSeen"] == null ||
          data.docChanges.last.doc.id == curUser.doc?["lastSeen"]) {
        print("Here 1");
        pageChanged = false;
      } /* else {
        print("Here 4");
        //pageChanged = true;
        isReachedEnd = true;
      }*/
    });*/

    //getFirstUserDoc();
    getNextUserDoc();
    super.initState();
  }

  @override
  void dispose() {
    feedSwiper.dispose();
    print("Here 3");
    curUser.uploadUserDoc();

    super.dispose();
  }

  @override
  Widget build(context) {
    getFirstUserDoc();
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Sasa",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              color: Colors.red,
              icon: const Icon(
                Icons.question_mark,
                size: 30,
              ),
              onPressed: () {
                curUser.clearMemory();
                print(MediaQuery.of(context).size.height);
              },
            ),
          ]),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      "Discover...",
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        /*
                        print(isReachedEnd);
                        if (isReachedEnd) {
                          return;
                        }
                        curUser.doc!["dislikedUsers"].remove(visitedUsers.last);
                        curUser.doc!["likedUsers"].remove(visitedUsers.last);
                        curUser.uploadUserDoc();*/
                      },
                      icon: const Icon(
                        Icons.restore_rounded,
                        size: 35,
                      ),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: users,
                    builder: (context, users) {
                      if ((users.connectionState == ConnectionState.waiting)) {
                        return Center(child: CircularProgressIndicator());
                      } else if (users.hasData & !isReachedEnd) {
                        String userProfileId = nextProfileId!;
                        print("Yoo ${curProfileId}");

                        curUser.doc!["lastSeen"] = userProfileId;

                        QueryDocumentSnapshot<Map<String, dynamic>?> userProfile =
                            users.data!.docs.where((element) => element.id == userProfileId).first;

                        void like() async {
                          bool isMatch = await curUser.checkMatch(userProfileId);
                          setState(() {
                            curUser.doc!["likedUsers"].add(userProfileId);

                            if (isMatch) {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text("You have a match!"),
                                  content: Text("Start in a conversation in the chats tab"),
                                ),
                              );
                            }

                            
                            curProfileId = nextProfileId;
                            getNextUserDoc(curUsers: users.data!);
                            curUser.uploadUserDoc();
                            pageChanged = true;
                          });
                        }

                        void dislike() {
                          setState(() {
                            curUser.doc!["dislikedUsers"].add(userProfileId);

                            curProfileId = nextProfileId;
                            getNextUserDoc(curUsers: users.data!);
                            curUser.uploadUserDoc();
                            pageChanged = true;
                          });
                        }

                        return profileCard(
                          ref,
                          true,
                          MediaQuery.of(context).size.height,
                          userProfile: userProfile.data(),
                          likeFunction: like,
                          dislikeFunction: dislike,
                        );
                      } else {
                        return const Center(child: Text("Nothing new here!"));
                      }
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }

  getNextUserDoc({QuerySnapshot<Map<String, dynamic>>? curUsers}) async {
    /*
  Map<String, bool> seenUsers = curUser.doc!["seenUsers"];
  Set<String> likedUsers = {};
  Set<String> dislikedUsers = {};

  seenUsers.forEach((key, isLiked) {
    if (isLiked) {
      likedUsers.add(key);
    } else {
      dislikedUsers.add(key);
    }
  });*/

    QuerySnapshot<Map<String, dynamic>> users =
        curUsers ?? await FirebaseFirestore.instance.collection('users').get();

    Set<String> likedSnapshots = users.docs
        .where((element) => curUser.doc!["likedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();

    Set<String> dislikedSnapshots = users.docs
        .where((element) => curUser.doc!["dislikedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();
    Set<String> feedSnapshots = users.docs
        .map((e) => e.id)
        .toSet()
        .difference(likedSnapshots)
        .difference(dislikedSnapshots)
        .difference({curProfileId, curUser.id});

    String? userProfileId = feedSnapshots.length > 0
        ? feedSnapshots.elementAt(Random().nextInt(feedSnapshots.length))
        : nextProfileId;

    if (feedSnapshots.length == 0) {
      print("Here 2");
      isReachedEnd = true;
    }

    nextProfileId = userProfileId;
  }

  getFirstUserDoc({QuerySnapshot<Map<String, dynamic>>? curUsers}) async {
    /*
  Map<String, bool> seenUsers = curUser.doc!["seenUsers"];
  Set<String> likedUsers = {};
  Set<String> dislikedUsers = {};

  seenUsers.forEach((key, isLiked) {
    if (isLiked) {
      likedUsers.add(key);
    } else {
      dislikedUsers.add(key);
    }
  });*/

    QuerySnapshot<Map<String, dynamic>> users =
        curUsers ?? await FirebaseFirestore.instance.collection('users').get();

    Set<String> likedSnapshots = users.docs
        .where((element) => curUser.doc!["likedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();

    Set<String> dislikedSnapshots = users.docs
        .where((element) => curUser.doc!["dislikedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();
    Set<String> feedSnapshots = users.docs
        .map((e) => e.id)
        .toSet()
        .difference(likedSnapshots)
        .difference(dislikedSnapshots)
        .difference({curUser.id});

    String? userProfileId = feedSnapshots.length > 0
        ? feedSnapshots.elementAt(Random().nextInt(feedSnapshots.length))
        : curProfileId;

    if (feedSnapshots.length == 0) {
      isReachedEnd = true;
    }
    print("Here 2");
    print(curUser.doc!["lastSeen"]);
    curProfileId = curUser.doc!["lastSeen"] ?? userProfileId;
  }
}
