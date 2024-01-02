import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sasa_mobile_app/providers.dart';
import 'package:sasa_mobile_app/screens/chat.dart';
import 'package:sasa_mobile_app/screens/profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sasa_mobile_app/widgets/profile_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
      FirebaseFirestore.instance.collection('users').snapshots();

  List<String> visitedUsers = [];

  late PageController feedSwiper = PageController(keepPage: true);
  var currentPage = 0;

  @override
  void initState() {
    getFeed() async {
      var initialPage = await curUser.getCurPage();
      feedSwiper = PageController(initialPage: 0 /*initialPage.toInt()*/, keepPage: true);
    }

    getFeed();

    //feedSwiper = PageController(keepPage: true);
    /*
    snapshots.listen((querySnapshot) {
      //users.removeAll
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        //querySnapshot.docChanges[0].type == DocumentChangeType.added
        users.add(document.data() as Map<String, dynamic>);
      }
    });
    */

    super.initState();
  }

  @override
  void dispose() {
    feedSwiper.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
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
                        curUser.dislikedUsers.remove(visitedUsers.last);
                        curUser.likedUsers.remove(visitedUsers.last);
                        curUser.updateLikesOrDislikes();
                        feedSwiper.previousPage(
                            duration: Duration(milliseconds: 500), curve: Curves.ease);
                        curUser.saveCurPage(feedSwiper.page! - 1);
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
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where(FieldPath.documentId, isNotEqualTo: authenticatedUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("yo ${snapshot.data!.size}");
                      var users = snapshot.data!.docs;
                      return PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: feedSwiper,
                          itemCount: users.length,
                          onPageChanged: (page) {
                            if (currentPage < page) {
                              visitedUsers.add(users[currentPage].id);
                            } else {
                              visitedUsers.removeLast();
                            }
                            currentPage = page;
                          },
                          itemBuilder: (context, index) {
                            curUser.updateLikesOrDislikes();
                            void like() async {
                              bool isMatch = await curUser.checkMatch(users[index].id);
                              if (isMatch) {
                                if (!context.mounted) return;
                                showDialog(
                                    context: context,
                                    builder: (context) => const AlertDialog(
                                          title: Text("You have a match!"),
                                          content: Text("Start in a conversation in the chats tab"),
                                        ));
                              }
                              feedSwiper.nextPage(
                                  duration: Duration(milliseconds: 500), curve: Curves.ease);
                              curUser.saveCurPage(feedSwiper.page! + 1);
                            }

                            void dislike() {
                              curUser.dislikedUsers.add(users[index].id);
                              feedSwiper.nextPage(
                                  duration: Duration(milliseconds: 500), curve: Curves.ease);
                              curUser.saveCurPage(feedSwiper.page! + 1);
                            }

                            if (currentPage > snapshot.data!.size) {
                              return const Center(child: Text("Nothing new here!"));
                            }

                            return profileCard(
                              ref,
                              true,
                              userProfile: users[index].data(),
                              likeFunction: like,
                              dislikeFunction: dislike,
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



/*
ListView.builder(
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return profileCard(ref, true, userProfile: users[index]);
          return Placeholder(); //Flexible(child: profileCard(ref, true, userProfile: users[index]));
        });
*/ 
/*
Scaffold(
      body: Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return profileCard(ref, true, userProfile: users[index]);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(users.length);
          return;
        },
        child: const Icon(Icons.upload),
      ),
    );
*/
