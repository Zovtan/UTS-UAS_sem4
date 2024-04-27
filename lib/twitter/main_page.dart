import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:twitter/twitter/twt_app_bar.dart';
import 'package:twitter/twitter/twt_bottom_bar.dart';

class MainPage extends StatefulWidget {
  /* final int userId; */
  final String currUsername;
  final String currDisplayName;
  const MainPage({
    Key? key,
    required this.currUsername,
    required this.currDisplayName,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class Tweet {
  final int id;
  final String username;
  final String displayName;
  final String tweet;
  final String image;
  final DateTime timestamp;
  final int likes;
  final int retweets;
  int commentCount;

  Tweet({
    required this.id,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    this.commentCount = 0,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    // Parse timestamp string into DateTime object
    DateTime parsedTimestamp = DateTime.parse(json['timestamp']);
    return Tweet(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      tweet: json['tweet'],
      image: json['image'],
      timestamp: parsedTimestamp,
      likes: json['likes'],
      retweets: json['retweets'],
    );
  }
}

class _MainPageState extends State<MainPage> {
  List<Tweet> tweets = [];
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTweets();
    _countComments(); // Call the method to count comments
  }

  Future<void> _loadTweets() async {
    // Read the JSON file
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/tweets.json');
    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Populate the list of tweets
    setState(() {
      tweets = jsonList.map((json) => Tweet.fromJson(json)).toList();
    });
  }

  //Hitung komen dalam json komen lalu kirim kesini
  Future<void> _countComments() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      for (var tweet in tweets) {
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
      appBar: TwitterAppBar(),
      bottomNavigationBar: TwitterBottomBar(),
      body: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          //listview harus di warp oleh sizebox atau expanded
          itemCount: tweets.length,
          itemBuilder: (BuildContext context, int index) {
            Tweet tweet = tweets[index];
            // Format timestamp using DateFormat
            String formattedTimestamp =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(tweet.timestamp);
            return ListTile(
              //navigasi
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentPage(
                        tweetId: tweet.id,
                        tweets: tweets //kirim id tweet dan data tweet
                        ),
                  ),
                );
              },
              title: Text(tweet.tweet),
              subtitle: Text(
                  '${tweet.username} - $formattedTimestamp (${tweet.commentCount} comments)'),
              leading: tweet.image != "none"
                  ? Image.asset(
                      tweet.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : null,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
      ),
    );
  }
}
