import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twitter/twitter/main_page.dart'; // Import the Tweet class from the main page

class Comment {
  final int commentId;
  final String username;
  final String displayName;
  final String comment;

  Comment({
    required this.commentId,
    required this.username,
    required this.displayName,
    required this.comment,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      username: json['username'],
      displayName: json['displayName'],
      comment: json['comment'],
    );
  }
}

class CommentPage extends StatefulWidget {
  final int tweetId;
  final List<Tweet> tweets; // Receive the list of tweets

  const CommentPage({Key? key, required this.tweetId, required this.tweets}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments = [];
  late Tweet tweet; // variabel berisi class tweet yg di import

  @override
  void initState() {
    super.initState();
    _loadTweet();
    _loadComments();
  }

  Future<void> _loadTweet() async {
    // Find the corresponding tweet using the tweetId from the received tweets list
    tweet = widget.tweets.firstWhere((tweet) => tweet.id == widget.tweetId);
  }

  Future<void> _loadComments() async {
    // Read the JSON file
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Find comments for the selected tweet ID
    Map<String, dynamic>? tweetComments = jsonList.firstWhere(
      (element) => element['tweet_id'] == widget.tweetId,
      orElse: () => null,
    );
    // Populate the list of comments
    if (tweetComments != null) {
      List<dynamic> commentsList = tweetComments['comments'];
      setState(() {
        comments = commentsList.map((json) => Comment.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Column(
        children: [Text(tweet.username),
        Text(tweet.displayName),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                Comment comment = comments[index];
                return ListTile(
                  title: Text(comment.comment),
                  subtitle: Text('${comment.username} - ${comment.displayName}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

