import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/model/tweets_mdl.dart'; // Update import to match your TweetMdl file

class EditTweetPage extends StatefulWidget {
  final TweetMdl tweet;
  final Function(TweetMdl) onTweetEdited;

  const EditTweetPage(
      {Key? key, required this.tweet, required this.onTweetEdited});

  @override
  EditTweetPageState createState() => EditTweetPageState();
}

class EditTweetPageState extends State<EditTweetPage> {
  late TextEditingController _tweetController;

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController(text: widget.tweet.tweet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Edit Tweet'),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_tweetController.text.isNotEmpty) {
                _editTweet();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  margin: const EdgeInsetsDirectional.only(end: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfilePicture(
                        name: widget.tweet.displayName,
                        radius: 31,
                        fontsize: 10,
                        count: 2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _tweetController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Don't leave edited tweet empty",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 101, 119, 134),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editTweet() {
    TweetMdl editedTweet = TweetMdl(
      twtId: widget.tweet.twtId,
      userId: widget.tweet.userId,
      username: widget.tweet.username,
      displayName: widget.tweet.displayName,
      tweet: _tweetController.text,
      image: widget.tweet.image,
      timestamp: widget.tweet.timestamp,
      likes: widget.tweet.likes,
      retweets: widget.tweet.retweets,
      qtweets: widget.tweet.qtweets,
      views: widget.tweet.views,
      bookmarks: widget.tweet.bookmarks,
      commentCount: widget.tweet.commentCount,
      interactions: Interactions(
        isLiked: widget.tweet.interactions.isLiked,
        isRetweeted: widget.tweet.interactions.isRetweeted,
        isBookmarked: widget.tweet.interactions.isBookmarked,
      ),
    );

    widget.onTweetEdited(editedTweet);

    Navigator.of(context).pop();
  }
}
