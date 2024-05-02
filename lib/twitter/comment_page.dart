import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/widget/edit_tweet.dart';

class CommentPage extends StatefulWidget {
  final Tweet tweet;
  final int commentCount;
  final int currId;
  final Function(int) formatNumber;
  final Function(Tweet) onTweetEdited;
  final Function(int) onDeleteTweet;
  final Function() onLikePressed;
  final Function() onRetweetPressed;
  final Function() onBookmarkPressed;

  CommentPage({
    Key? key,
    required this.tweet,
    required this.commentCount,
    required this.currId,
    required this.formatNumber,
    required this.onTweetEdited,
    required this.onDeleteTweet,
    required this.onLikePressed,
    required this.onRetweetPressed,
    required this.onBookmarkPressed,
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
  bool isLiked = false;
  bool isRetweeted = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
    // sinkron dengan data yg baru diedit
    isLiked = widget.tweet.isLiked;
    isRetweeted = widget.tweet.isRetweeted;
    isBookmarked = widget.tweet.isBookmarked;
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
    //format waktu
    DateTime parsedTimestamp = DateTime.parse(widget.tweet.timestamp);
    String formattedTimestamp =
        DateFormat('h:mm a • dd MMM yy').format(parsedTimestamp);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Post'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //tweet utama
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //pfp, name, follow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ProfilePicture(
                                name: widget.tweet.displayName,
                                radius: 18,
                                fontsize: 10,
                                count: 2,
                              ),
                              Column(
                                children: [
                                  Text(
                                    widget.tweet.displayName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.tweet.username,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 101, 119, 134)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (widget.tweet.userId != widget.currId)
                            SizedBox(
                              height: 25,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Follow",
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                              ),
                            ),
                          //hanya muncul jika ada tweet sendiri
                          if (widget.tweet.userId ==
                              widget
                                  .currId) // Conditionally render PopupMenuButton
                            PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit tweet'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete tweet'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'Edit') {
                                  _editTweet(); // Call the function to handle tweet editing
                                } else if (value == 'Delete') {
                                  widget.onDeleteTweet(widget.tweet
                                      .twtId); // Handle delete tweet action
                                }
                              },
                              child: Icon(
                                Icons.more_vert_rounded,
                                color: Color.fromARGB(255, 101, 119, 134),
                                size: 15,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(widget.tweet.tweet),
                      SizedBox(height: 5),
                      if (widget.tweet.image != "none") ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(widget.tweet.image),
                        ),
                        SizedBox(height: 5),
                      ],
                      Column(
                        children: [
                          //waktu dan view
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: formattedTimestamp + " • ",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                      TextSpan(
                                        text: widget
                                            .formatNumber(widget.tweet.views),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: " Views",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color.fromARGB(255, 101, 119, 134),
                            height: 1,
                          ),
                          //retweet, qtweet, likes, bookmark
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${widget.formatNumber(widget.tweet.retweets)} ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Reposts',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${widget.formatNumber(widget.tweet.qtweets)} ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Quotes',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${widget.formatNumber(widget.tweet.likes)} ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Likes',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${widget.formatNumber(widget.tweet.bookmarks)} ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: 'Bookmarks',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color.fromARGB(255, 101, 119, 134),
                            height: 1,
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                      // Like, Retweet, Comment, and other icons
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  onLikePressed();
                                },
                                child: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: isLiked
                                      ? Colors.red
                                      : Color.fromARGB(255, 101, 119, 134),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  onRetweetPressed();
                                },
                                child: Icon(
                                  isRetweeted
                                      ? Icons.repeat
                                      : Icons.repeat_rounded,
                                  size: 16,
                                  color: isRetweeted
                                      ? Colors.green
                                      : Color.fromARGB(255, 101, 119, 134),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.mode_comment_outlined,
                                      size: 16,
                                      color:
                                          Color.fromARGB(255, 101, 119, 134)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  onBookmarkPressed();
                                },
                                child: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 16,
                                  color: isBookmarked
                                      ? Colors.blue
                                      : Color.fromARGB(255, 101, 119, 134),
                                ),
                              ),
                              Icon(Icons.share_outlined,
                                  size: 16,
                                  color: Color.fromARGB(255, 101, 119, 134)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Color.fromARGB(255, 101, 119, 134),
                            height: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            //komentar
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(), //mencegah double scroll
                shrinkWrap: true,
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
      ),
    );
  }

  void _editTweet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          tweet: widget.tweet,
          onTweetEdited: (editedTweet) {
            widget.onTweetEdited(
                editedTweet); // Pass the edited tweet to the parent widget
          },
        ),
      ),
    );
  }

  // implementasi fungsi yg diterima dan kirim balik data ke tweetcell
  void onLikePressed() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLikePressed(); // Notify parent widget
  }

  void onRetweetPressed() {
    setState(() {
      isRetweeted = !isRetweeted;
    });
    widget.onRetweetPressed(); // Notify parent widget
  }

  void onBookmarkPressed() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    widget.onBookmarkPressed(); // Notify parent widget
  }
}
