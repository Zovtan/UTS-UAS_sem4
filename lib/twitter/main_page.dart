import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:twitter/twitter/twt_app_bar.dart';
import 'package:twitter/twitter/twt_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class Tweet {
  final int id;
  final String author;
  final String username;
  final String tweet;
  final String image;
  final DateTime timestamp;
  final int likes;
  final int retweets;
  int commentCount;

  Tweet({
    required this.id,
    required this.author,
    required this.username,
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
      author: json['author'],
      username: json['username'],
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

  //This modification adds a commentCount property to the Tweet class and initializes it to 0. Then, in the _countComments method, it counts the comments for each tweet and updates the commentCount property accordingly. Finally, in the build method, it displays the comment count along with other tweet information.
Future<void> _countComments() async {
  String jsonString = await DefaultAssetBundle.of(context)
      .loadString('assets/json/comments.json');
  List<dynamic> jsonList = jsonDecode(jsonString);
  setState(() {
    for (var tweet in tweets) {
      // Find the comments for the tweet
      var commentsInTweet = jsonList.firstWhere(
        (comment) => comment['tweet_id'] == tweet.id,
        orElse: () => {'comments': []}, // If no comments found, use an empty list
      )['comments'];
      // Update the comment count
      tweet.commentCount = commentsInTweet.length;
    }
  });
}


  @override
  Widget build(BuildContext context) {
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
              subtitle:
                  Text('${tweet.author} - $formattedTimestamp (${tweet.commentCount} comments)'),
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
