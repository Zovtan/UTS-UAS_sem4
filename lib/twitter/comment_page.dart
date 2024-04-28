import 'dart:convert';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final int tweetId;
  final String username;
  final String displayName;
  final String tweet;
  final String image;
  final String timestamp;
  final int likes;
  final int retweets;
  final int commentCount;

  const CommentPage({
    Key? key,
    required this.tweetId,
    required this.username,
    required this.displayName,
    required this.tweet,
    required this.image,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.commentCount,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    // Read the JSON file
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Find comments for the selected CommentPage ID
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
    } else {
      // No comments found for the selected CommentPage
      // You can display a message or handle this case accordingly
      setState(() {
        // Set comments to an empty list
        comments = [];
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
          Text(widget.username),
          Text(widget.displayName),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                Comment comment = comments[index];
                return ListTile(
                  title: Text(comment.comment),
                  subtitle:
                      Text('${comment.username} - ${comment.displayName}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
