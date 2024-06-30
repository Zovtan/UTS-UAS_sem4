import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final Tweet tweet;
  final int? currId;

  const CommentPage({
    Key? key,
    required this.tweet,
    required this.currId,
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
  late bool isLiked;
  late bool isRetweeted;
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    _loadComments();
    isLiked = widget.tweet.isLiked;
    isRetweeted = widget.tweet.isRetweeted;
    isBookmarked = widget.tweet.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedTimestamp = DateTime.parse(widget.tweet.timestamp);
    String formattedTimestamp =
        DateFormat('h:mm a • dd MMM yy').format(parsedTimestamp);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Post'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main tweet (first row)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture, name, follow, options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // ProfilePicture widget and name display
                              ProfilePicture(
                                name: widget.tweet.displayName,
                                radius: 18,
                                fontsize: 10,
                                count: 2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.tweet.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    widget.tweet.username,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                        fontSize: 16),
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
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                child: const Text(
                                  "Follow",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          if (widget.tweet.userId == widget.currId)
                            PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit tweet'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete tweet'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'Edit') {
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .editTweet(context, widget.tweet);
                                } else if (value == 'Delete') {
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .deleteTweet(widget.tweet.twtId);
                                }
                              },
                              child: const Icon(
                                Icons.more_vert_rounded,
                                color: Color.fromARGB(255, 101, 119, 134),
                                size: 15,
                              ),
                            ),
                        ],
                      ),

                      // Tweet text and image
                      const SizedBox(height: 5),
                      Text(
                        widget.tweet.tweet,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      if (widget.tweet.image != "none") ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(widget.tweet.image),
                        ),
                        const SizedBox(height: 5),
                      ],

                      // Info
                      Consumer<TweetProvider>(
                        builder: (context, tweetProvider, _) {
                          return Column(
                            children: [
                              // Timestamp and view count
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '$formattedTimestamp • ',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: tweetProvider.formatNumber(
                                                widget.tweet.views),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: " Views",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Divider(
                                color: Color.fromARGB(120, 101, 119, 134),
                                height: 1,
                              ),
                              const SizedBox(height: 7),

                              // Retweets, quotes, likes, bookmarks
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${tweetProvider.formatNumber(widget.tweet.retweets)} ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: 'Reposts',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${tweetProvider.formatNumber(widget.tweet.qtweets)} ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: 'Quotes',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${tweetProvider.formatNumber(widget.tweet.likes)} ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: 'Likes',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${tweetProvider.formatNumber(widget.tweet.bookmarks)} ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: 'Bookmarks',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Divider(
                                color: Color.fromARGB(120, 101, 119, 134),
                                height: 1,
                              ),
                              const SizedBox(height: 7),
                            ],
                          );
                        },
                      ),

// Icons
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.mode_comment_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 101, 119, 134)),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isRetweeted = !isRetweeted;
                                  });
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .toggleRetweet(widget.tweet);
                                },
                                child: Icon(
                                  isRetweeted
                                      ? Icons.repeat
                                      : Icons.repeat_rounded,
                                  size: 24,
                                  color: isRetweeted
                                      ? Colors.green
                                      : const Color.fromARGB(
                                          255, 101, 119, 134),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .toggleLike(widget.tweet);
                                },
                                child: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 24,
                                  color: isLiked
                                      ? Colors.red
                                      : const Color.fromARGB(
                                          255, 101, 119, 134),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .toggleBookmark(widget.tweet);
                                },
                                child: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 24,
                                  color: isBookmarked
                                      ? Colors.blue
                                      : const Color.fromARGB(
                                          255, 101, 119, 134),
                                ),
                              ),
                              const Icon(Icons.share_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 101, 119, 134)),
                            ],
                          ),
                          const SizedBox(height: 7),
                          const Divider(
                            color: Color.fromARGB(120, 101, 119, 134),
                            height: 1,
                          ),
                          const SizedBox(height: 7),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Comments (second row)
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.5, // Set size for proper rendering in SingleChildScrollView
              child: ListView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Prevent double scroll
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = comments[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1
                      // Profile picture
                      Container(
                        width: 35,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfilePicture(
                              name: comment.displayName,
                              radius: 18,
                              fontsize: 10,
                              count: 2,
                            ),
                          ],
                        ),
                      ),

                      // Name and duration
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow
                                          .ellipsis, // Use ellipsis for overflow
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: comment.displayName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: ' ${comment.username}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: ' • ${Provider.of<TweetProvider>(context, listen: false).formatDur(parsedTimestamp)}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Comment text
                              SizedBox(height: 5),
                              Text(
                                comment.comment,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),

                              // Icons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.repeat_rounded,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mode_comment_outlined,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_chart_outlined_rounded,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 101, 119, 134),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bookmark_border,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.share_outlined,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 101, 119, 134),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadComments() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    Map<String, dynamic>? tweetComments = jsonList.firstWhere(
      (element) => element['twtId'] == widget.tweet.twtId,
      orElse: () => null,
    );
    if (tweetComments != null) {
      List<dynamic> commentsList = tweetComments['comments'];
      setState(() {
        comments = commentsList.map((json) => Comment.fromJson(json)).toList();
      });
    } else {
      setState(() {
        comments = [];
      });
    }
  }
}
