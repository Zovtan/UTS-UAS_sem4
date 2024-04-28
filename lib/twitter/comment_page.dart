import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twitter/class/tweets.dart';

class CommentPage extends StatefulWidget {
  final int tweetId;
  const CommentPage({Key? key, required this.tweetId}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

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

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments = [];
  late Tweet tweet; // late di paka pada saat variabel di aktifkan nanti, pada kasus ini, variabel tweet dipakai dlm initsate sebelum build

  @override
  void initState() {
    super.initState();
    _loadComments();
    // Find and set the corresponding tweet
    tweet = TweetData().tweets.firstWhere((tweet) => tweet.id == widget.tweetId);
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
        children: [
          Text(tweet.username),
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
