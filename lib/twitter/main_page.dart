import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:twitter/widget/twt_app_bar.dart';
import 'package:twitter/widget/twt_bottom_bar.dart';
import 'package:twitter/widget/post_tweet.dart';
import 'package:twitter/class/profiles.dart';

class MainPage extends StatefulWidget {
  final String currUsername;
  final String currDisplayName;
  final ProfileData profileData;
  const MainPage({
    Key? key,
    required this.currUsername,
    required this.currDisplayName,
    required this.profileData
  }) : super(key: key);

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
    bottomNavigationBar:TwitterBottomBar(),
      body: CustomScrollView(
        slivers: [
          //appbar
          TwitterAppBar(currDisplayName: widget.currDisplayName, profileData: profileData,), // Here's where you integrate the TwitterAppBar
          //Main content, ganti listbuilder dengan sliverlist supaya bisa pakai appbar yg responsive
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Tweet tweet = tweetData.tweets[index];
                DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
                String formattedTimestamp =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 0,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            tweetId: tweet.id,
                            username: tweet.username,
                            displayName: tweet.displayName,
                            tweet: tweet.tweet,
                            image: tweet.image,
                            timestamp: formattedTimestamp,
                            likes: tweet.likes,
                            retweets: tweet.retweets,
                            commentCount: commentCount,
                          ),
                        ),
                      );
                    },
                    title: Text(tweet.tweet),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          '${tweet.username} - $formattedTimestamp',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.comment, size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                              '${tweet.commentCount}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.favorite_border,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                              '${tweet.likes}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            SizedBox(width: 15),
                            Icon(Icons.repeat, size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(
                              '${tweet.retweets}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    leading: tweet.image != "none"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              tweet.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                  ),
                );
              },
              childCount: tweetData.tweets.length,
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
