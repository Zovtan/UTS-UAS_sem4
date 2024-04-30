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
  final String currUsername;
  final String currDisplayName;
  final ProfileData profileData;
  const MainPage(
      {Key? key,
      required this.currUsername,
      required this.currDisplayName,
      required this.profileData})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TweetData tweetData = TweetData();
  int commentCount = 0;
  late ProfileData profileData;

  @override
  void initState() {
    super.initState();
    _countComments(); // Call the method to count comments
    profileData = widget.profileData;
  }

  //Hitung komen dalam json komen lalu kirim kesini
  Future<void> _countComments() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      for (var tweet in tweetData.tweets) {
        // Find the comments for the tweet
        var commentsInTweet = jsonList.firstWhere(
          (comment) => comment['tweet_id'] == tweet.id,
          orElse: () =>
              {'comments': []}, // If no comments found, use an empty list
        )['comments'];
        // Update the comment count
        tweet.commentCount = commentsInTweet.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currUsername);
    print(widget.currDisplayName);

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
                //ganti tweet ganti jadi divider
                if (index.isOdd) {
                  return Divider(
                    color: Colors.red,
                  );
                } else {
                  // menggandakan tweet supaya untuk memadai penghapusan ganjil (setaip tweet jadi ada 2)
                  int tweetIndex = index ~/ 2;
                  // cek apakah index lbh kecil daripada length, ini supaya tdk ada tweet ganda di akhir
                  if (tweetIndex < tweetData.tweets.length) {
                    Tweet tweet = tweetData.tweets[tweetIndex];
                    DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
                    String formattedTimestamp =
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(parsedTimestamp);
                    return TweetCell(
                      tweet: tweet,
                      commentCount: commentCount,
                    );
                  } else {
                    // kalo index lbh besar dari lenght
                    return SizedBox();
                  }
                }
              },
              childCount: tweetData.tweets.length * 2 -
                  1, // Adjusted count for dividers
            ),
          ),
        ],
      ),

      //FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              //panggil widget post lalu masukkan tweet di post lalu kirim tweet balik ke mainpage terus update class tweet
              return AddTweetPage(
                onTweetAdded: (newTweet) {
                  setState(() {
                    tweetData.addTweet(Tweet(
                      id: tweetData.tweets.length + 1,
                      username: widget.currUsername,
                      displayName: widget.currDisplayName,
                      tweet: newTweet,
                      image: "none",
                      timestamp: DateTime.now().toIso8601String(),
                      likes: 0,
                      retweets: 0,
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
