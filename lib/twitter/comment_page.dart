import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/widget/edit_tweet.dart';

class CommentPage extends StatefulWidget {
  final Tweet tweet;
  final int commentCount;
  final int currId;
  final String formattedDur;
  final Function(int) formatNumber;
  final Function(Tweet) onTweetEdited;
  final Function(int) onDeleteTweet;
  final Function() onLikePressed;
  final Function() onRetweetPressed;
  final Function() onBookmarkPressed;

  const CommentPage({
    super.key,
    required this.tweet,
    required this.commentCount,
    required this.currId,
    required this.formattedDur,
    required this.formatNumber,
    required this.onTweetEdited,
    required this.onDeleteTweet,
    required this.onLikePressed,
    required this.onRetweetPressed,
    required this.onBookmarkPressed,
  });

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
    // sinkron dengan data yg baru diedit
    isLiked = widget.tweet.isLiked;
    isRetweeted = widget.tweet.isRetweeted;
    isBookmarked = widget.tweet.isBookmarked;
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
        title: const Text('Post'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //tweet utama (baris 1)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //pfp, name, follow, opsi
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
                          //hanya muncul jika ada tweet sendiri
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
                                  _editTweet();
                                } else if (value == 'Delete') {
                                  widget.onDeleteTweet(widget.tweet.twtId);
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

                      // tweet dan image
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

                      //info
                      Column(
                        children: [
                          //waktu dan view
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
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
                                        text: widget
                                            .formatNumber(widget.tweet.views),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                          const SizedBox(
                            height: 7,
                          ),
                          const Divider(
                            color: Color.fromARGB(120, 101, 119, 134),
                            height: 1,
                          ),
                          const SizedBox(
                            height: 7,
                          ),

                          //jumlah retweet, qtweet, likes, bookmark
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${widget.formatNumber(widget.tweet.retweets)} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                                            '  ${widget.formatNumber(widget.tweet.qtweets)} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                                            '  ${widget.formatNumber(widget.tweet.likes)} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                                            '  ${widget.formatNumber(widget.tweet.bookmarks)} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
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
                          const SizedBox(
                            height: 7,
                          ),
                          const Divider(
                            color: Color.fromARGB(120, 101, 119, 134),
                            height: 1,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),

                      // icons
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
                                  onRetweetPressed();
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
                                  onLikePressed();
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
                                  onBookmarkPressed();
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
                          const SizedBox(
                            height: 7,
                          ),
                          const Divider(
                            color: Color.fromARGB(120, 101, 119, 134),
                            height: 1,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),

            //komentar (baris 2)
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.5, // diberi ukuran supaya bisa dirender oleh singlechildslider
              child: ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), //mencegah double scroll
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Comment comment = comments[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //kolom 1
                      //pfp
                      Container(
                        width: 35,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
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

                      //nama dan durasi
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(5),
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
                                          .ellipsis, //jika ada overflow tambal pakai ...
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: comment.displayName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: ' ${comment.username}',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 101, 119, 134),
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: ' • ${widget.formattedDur}',
                                            style: const TextStyle(
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

                              //isi komentar
                              const SizedBox(height: 5),
                              Text(
                                comment.comment,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),

                              //icons
                              const Row(
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
                                      Icon(Icons.mode_comment_outlined,
                                          size: 20,
                                          color: Color.fromARGB(
                                              255, 101, 119, 134)),
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
                                      Icon(Icons.insert_chart_outlined_rounded,
                                          size: 20,
                                          color: Color.fromARGB(
                                              255, 101, 119, 134)),
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
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.share_outlined,
                                          size: 20,
                                          color: Color.fromARGB(
                                              255, 101, 119, 134)),
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
    // baca file json
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);
    // komen yg sesuai dengan tweet yg dibalas
    Map<String, dynamic>? tweetComments = jsonList.firstWhere(
      (element) => element['twtId'] == widget.tweet.twtId,
      orElse: () => null,
    );
    // isi list dgn json
    if (tweetComments != null) {
      List<dynamic> commentsList = tweetComments['comments'];
      setState(() {
        comments = commentsList.map((json) => Comment.fromJson(json)).toList();
      });
    } else {
      //kirim kossong jika tdk ada komen
      setState(() {
        comments = [];
      });
    }
  }

  void _editTweet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          tweet: widget.tweet,
          onTweetEdited: (editedTweet) {
            widget.onTweetEdited(
                editedTweet); //kirim edited tweet ke parent widget
          },
        ),
      ),
    );
  }

  // implementasi fungsi utk render ulang value yg terupdate dan memulai fungsi yg dikirim dari tweet_cell
  void onLikePressed() {
    setState(() {
      isLiked = !isLiked;
    });
    widget.onLikePressed(); // peringati parent widget
  }

  void onRetweetPressed() {
    setState(() {
      isRetweeted = !isRetweeted;
    });
    widget.onRetweetPressed();
  }

  void onBookmarkPressed() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    widget.onBookmarkPressed();
  }
}
