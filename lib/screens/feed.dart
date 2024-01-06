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
  Stream<QuerySnapshot<Map<String, dynamic>>> feedSnapshots =
      FirebaseFirestore.instance.collection('users').snapshots();

  List<String> visitedUsers = [];

  late PageController feedSwiper = PageController(keepPage: true);
  var currentPage = 0;
  bool isReachedEnd = false;

  @override
  void initState() {
    curUser.reloadDetails(ref);
    /*
    getFeed() async {
      currentPage = await curUser.getCurPage().then((value) => value.toInt());
      feedSwiper = PageController(initialPage: currentPage.toInt(), keepPage: true);
    }

    getFeed();
    */

    //feedSwiper = PageController(keepPage: true);

    /*
    feedSnapshots.listen((querySnapshot) {
      //users.removeAll
      querySnapshot.docChanges.where((change) {
        return change.type == DocumentChangeType.added;
      });
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
                        print(isReachedEnd);
                        if (isReachedEnd) {
                          return;
                        }
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
                      .where(FieldPath.documentId,
                          whereNotIn: [authenticatedUser.uid] + List.from(curUser.matches))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.waiting)) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData &&
                        snapshot.data!.size > 0 &&
                        currentPage < snapshot.data!.size - 1) {
                      isReachedEnd = false;
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
                              //To generate a new page
                              print("yo ${currentPage}");
                              print("hi ${snapshot.data!.size - 1}");
                              if (currentPage >= snapshot.data!.size - 1) {
                                print("Here");
                                setState(() {
                                  curUser.saveCurPage(feedSwiper.page! + 1);
                                  isReachedEnd = true;
                                });
                              }

                              bool isMatch = await curUser.checkMatch(users[index].id);
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

                            return profileCard(
                              ref,
                              true,
                              MediaQuery.of(context).size.height,
                              userProfile: users[index].data(),
                              likeFunction: like,
                              dislikeFunction: dislike,
                            );
                          });
                    } else {
                      return const Center(child: Text("Nothing new here!"));
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
