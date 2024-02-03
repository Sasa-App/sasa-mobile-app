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

  List<String> visitedUsers = [];

  late PageController feedSwiper = PageController();
  var currentPage = 0;

  bool isReachedEnd = false;

  @override
  void initState() {
    curUser.downloadUserDoc(ref);
    super.initState();
  }

  @override
  void dispose() {
    feedSwiper.dispose();
    curUser.uploadUserDoc();
    super.dispose();
  }

  @override
  Widget build(context) {
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
                        feedSwiper.previousPage(
                            duration: Duration(milliseconds: 500), curve: Curves.ease);
                        curUser.saveCurPage(feedSwiper.page! - 1);*/
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
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: getGeneralFeed(),
                    builder: (context, usersSnapshot) {
                      if ((usersSnapshot.connectionState == ConnectionState.waiting)) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        ));
                      } else if (usersSnapshot.hasData & !isReachedEnd) {
                        return FutureBuilder<List<String>>(
                            future: getFeed(curUsers: usersSnapshot.data!),
                            builder: (context, feedSnapshot) {
                              if (feedSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.red,
                                ));
                              } else if (feedSnapshot.hasData &&
                                  currentPage < feedSnapshot.data!.length) {
                                return PageView.builder(
                                    controller: feedSwiper,
                                    itemCount: feedSnapshot.data!.length,
                                    onPageChanged: (page) {
                                      /*
                                      if (currentPage < page) {
                                        visitedUsers.add(snapshot.data![currentPage]);
                                      } else {
                                        visitedUsers.removeLast();
                                      }*/
                                      //currentPage = 1;
                                      //curUser.uploadUserDoc();
                                    },
                                    itemBuilder: (context, index) {
                                      List<String> feed = feedSnapshot.data!;
                                      String feedUserProfileId = feed[currentPage];

                                      QueryDocumentSnapshot<Map<String, dynamic>?> feedUserProfile =
                                          usersSnapshot.data!.docs
                                              .where((element) => element.id == feedUserProfileId)
                                              .first;

                                      void like() async {
                                        bool isMatch = await curUser.checkMatch(feedUserProfileId);

                                        curUser.doc!["likedUsers"].add(feedUserProfileId);

                                        if (isMatch) {
                                          if (!context.mounted) return;
                                          showDialog(
                                            context: context,
                                            builder: (context) => const AlertDialog(
                                              title: Text("You have a match!"),
                                              content:
                                                  Text("Start in a conversation in the chats tab"),
                                            ),
                                          );
                                        } 
                                        currentPage += 1;

                                        if (currentPage >= feed.length) {
                                          setState(() {
                                            //getGeneralFeed
                                            isReachedEnd = true;
                                          });
                                        }
                                       
                                        feedSwiper.nextPage(
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                        curUser.uploadUserDoc();
                                      }

                                      void dislike() {
                                        curUser.doc!["dislikedUsers"].add(feedUserProfileId);
                                        currentPage += 1;
                                        if (currentPage >= feed.length) {
                                          setState(() {
                                            //getGeneralFeed
                                            isReachedEnd = true;
                                          });
                                        }
                                        feedSwiper.nextPage(
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                        curUser.uploadUserDoc();
                                      }

                                      return profileCard(
                                        ref,
                                        MediaQuery.of(context).size.height,
                                        isDisplayedonFeed: true,
                                        userProfile: feedUserProfile.data(),
                                        likeFunction: like,
                                        dislikeFunction: dislike,
                                      );
                                    });
                              } else {
                                return const Center(child: Text("Nothing new here!"));
                              }
                            });
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

  Future<QuerySnapshot<Map<String, dynamic>>> getGeneralFeed() async {
    QuerySnapshot<Map<String, dynamic>> users =
        await FirebaseFirestore.instance
        .collection('users')
        .where('gender', isEqualTo: curUser.doc!["interestedIn"])
        .get();

    return users;
  }

  Future<List<String>> getFeed({required QuerySnapshot<Map<String, dynamic>> curUsers}) async {
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

    Set<String> likedSnapshots = curUsers.docs
        .where((element) => curUser.doc!["likedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();

    Set<String> dislikedSnapshots = curUsers.docs
        .where((element) => curUser.doc!["dislikedUsers"].contains(element.id))
        .map((e) => e.id)
        .toSet();
    Set<String> feedSnapshots = curUsers.docs
        .map((e) => e.id)
        .toSet()
        .difference(likedSnapshots)
        .difference(dislikedSnapshots)
        .difference({curUser.id});

    print("Here");

    return feedSnapshots.toList();
  }
}
