import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/widget/tweet_cell.dart';
import 'package:twitter/widget/twt_app_bar.dart';
import 'package:twitter/widget/twt_bottom_bar.dart';
import 'package:twitter/widget/post_tweet.dart';
import 'package:twitter/class/profiles.dart';

class MainPage extends StatefulWidget {
  final int currId;
  final String currUsername;
  final String currDisplayName;
  final ProfileData profileData;

  const MainPage(
      {Key? key,
      required this.currId,
      required this.currUsername,
      required this.currDisplayName,
      required this.profileData})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TweetData tweetData = TweetData();
  late ProfileData profileData;

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
  }

  void _editTweet(Tweet editedTweet) {
    setState(() {
      int index = tweetData.tweets.indexWhere((tweet) => tweet.id == editedTweet.id);
      if (index != -1) {
        tweetData.tweets[index] = editedTweet;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TwitterBottomBar(),
      body: CustomScrollView(
        slivers: [
          TwitterAppBar(
            currDisplayName: widget.currDisplayName,
            profileData: profileData,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index.isOdd) {
                  return Divider(
                    color: Color.fromARGB(120, 101, 119, 134),
                  );
                } else {
                  int tweetIndex = index ~/ 2;
                  if (tweetIndex < tweetData.tweets.length) {
                    Tweet tweet = tweetData.tweets[tweetIndex];
                    DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
                    String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);
                    var durTime = DateTime.now().difference(parsedTimestamp);
                    String formattedDur;
                    if (durTime.inDays > 0) {
                      formattedDur = "${durTime.inDays}d";
                    } else if (durTime.inHours > 0) {
                      formattedDur = "${durTime.inHours}h";
                    } else if (durTime.inMinutes > 0) {
                      formattedDur = "${durTime.inMinutes}m";
                    } else {
                      formattedDur = "Less than a minute";
                    }
                    return TweetCell(
                      tweet: tweet,
                      commentCount: tweet.commentCount, // Pass the actual comment count
                      formattedDur: formattedDur,
                      onTweetEdited: _editTweet,
                      currId: widget.currId,
                    );
                  } else {
                    return SizedBox();
                  }
                }
              },
              childCount: tweetData.tweets.length * 2 - 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTweetPage(
                onTweetAdded: (newTweet) {
                  setState(() {
                    tweetData.addTweet(Tweet(
                      id: tweetData.tweets.length + 1,
                      userId: widget.currId,
                      username: widget.currUsername,
                      displayName: widget.currDisplayName,
                      tweet: newTweet,
                      image: "none",
                      timestamp: DateTime.now().toIso8601String(),
                      likes: 0,
                      retweets: 0,
                      views: 0,
                      bookmarks: 0,
                      commentCount: 0,
                    ));
                  });
                },
                currDisplayName: widget.currDisplayName,
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
