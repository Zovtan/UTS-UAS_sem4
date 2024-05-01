import 'package:flutter/material.dart';
import 'package:twitter/class/tweets.dart';

class EditTweetPage extends StatefulWidget {
  final Tweet tweet;
  final Function(Tweet) onTweetEdited;

  EditTweetPage({required this.tweet, required this.onTweetEdited});

  @override
  _EditTweetPageState createState() => _EditTweetPageState();
}

class _EditTweetPageState extends State<EditTweetPage> {
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
        title: Text('Edit Tweet'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tweetController,
              maxLines: null, // Allow multiple lines for editing
              decoration: InputDecoration(
                hintText: 'Enter your tweet',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _editTweet();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

void _editTweet() {
  // Create the edited tweet based on the text in the TextField
  Tweet editedTweet = Tweet(
    id: widget.tweet.id,
    userId: widget.tweet.userId,
    username: widget.tweet.username,
    displayName: widget.tweet.displayName,
    tweet: _tweetController.text,
    image: widget.tweet.image,
    timestamp: widget.tweet.timestamp,
    likes: widget.tweet.likes,
    retweets: widget.tweet.retweets,
    views: widget.tweet.views,
    bookmarks: widget.tweet.bookmarks,
    commentCount: widget.tweet.commentCount,
  );

  // Pass the edited tweet back to the previous screen
  widget.onTweetEdited(editedTweet);
  
  // Close the current screen
  Navigator.of(context).pop();
}
}
