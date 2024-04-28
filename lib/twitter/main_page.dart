import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
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

class _MainPageState extends State<MainPage> {
  final TweetData tweetData = TweetData();
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _countComments(); // Call the method to count comments
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
      appBar: TwitterAppBar(),
      bottomNavigationBar: TwitterBottomBar(),
      body: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          //listview harus di warp oleh sizebox atau expanded
          itemCount: tweetData.tweets.length,
          itemBuilder: (BuildContext context, int index) {
            Tweet tweet = tweetData.tweets[index];
            // Format timestamp using DateFormat
            DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
            String formattedTimestamp =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);
            return ListTile(
              //navigasi
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentPage(
                        tweetId: tweet.id,
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
