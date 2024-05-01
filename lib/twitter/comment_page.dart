import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twitter/class/tweets.dart';

class CommentPage extends StatefulWidget {
  final Tweet tweet;
  final int commentCount;
  final String formattedDur;
  final int currId;

  const CommentPage(
      {Key? key,
      required this.tweet,
      required this.commentCount,
      required this.formattedDur,
      required this.currId,
})
      : super(key: key);

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
      (element) => element['twtId'] == widget.tweet.twtId,
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
          Text(widget.tweet.username),
          Text(widget.tweet.displayName),
          Text(widget.tweet.tweet),
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
