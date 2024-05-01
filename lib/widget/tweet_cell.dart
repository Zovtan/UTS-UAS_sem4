import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/twitter/comment_page.dart';

class TweetCell extends StatefulWidget {
  final Tweet tweet;
  final int commentCount;
  final String formattedDur;

  const TweetCell(
      {Key? key,
      required this.tweet,
      required this.commentCount,
      required this.formattedDur})
      : super(key: key);

  @override
  _TweetCellState createState() => _TweetCellState();
}

class _TweetCellState extends State<TweetCell> {
  bool isLiked = false;
  bool isRetweeted = false;
  bool isBookmarked = false;
  //format angka yg lbh dari 999 jadi 1.0k
  String formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      return numberInK.toStringAsFixed(1) + 'k';
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedTimestamp = DateTime.parse(widget.tweet.timestamp);
    String formattedTimestamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommentPage(
              tweetId: widget.tweet.id,
              username: widget.tweet.username,
              displayName: widget.tweet.displayName,
              tweet: widget.tweet.tweet,
              image: widget.tweet.image,
              timestamp: formattedTimestamp,
              likes: widget.tweet.likes,
              retweets: widget.tweet.retweets,
              views: widget.tweet.views,
              commentCount: widget.commentCount,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Container(
            width: 35,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture(
                  name: widget.tweet.displayName,
                  radius: 18,
                  fontsize: 10,
                  count: 2,
                ),
              ],
            ),
          ),

          // Right column
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.tweet.displayName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " " + widget.tweet.username,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 101, 119, 134)),
                            ),
                            TextSpan(
                              text: " • " + widget.formattedDur,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 101, 119, 134)),
                            )
                          ],
                        ),
                      ),

                      //kalo pake icon button ada margin tersembunyi
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
                            // Handle edit tweet action
                          } else if (value == 'Delete') {
                            // Handle delete tweet action
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                            if (isLiked) {
                              widget.tweet.likes++;
                            } else {
                              widget.tweet.likes--;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isLiked
                                  ? Colors.red
                                  : Color.fromARGB(255, 101, 119, 134),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${formatNumber(widget.tweet.likes)}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 101, 119, 134),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isRetweeted = !isRetweeted;
                            if (isRetweeted) {
                              widget.tweet.retweets++;
                            } else {
                              widget.tweet.retweets--;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              isRetweeted ? Icons.repeat : Icons.repeat_rounded,
                              size: 16,
                              color: isRetweeted
                                  ? Colors.green
                                  : Color.fromARGB(255, 101, 119, 134),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${formatNumber(widget.tweet.retweets)}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 101, 119, 134),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.mode_comment_outlined,
                              size: 16,
                              color: Color.fromARGB(255, 101, 119, 134)),
                          SizedBox(width: 5),
                          Text(
                            '${formatNumber(widget.tweet.commentCount)}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.insert_chart_outlined_rounded,
                              size: 16,
                              color: Color.fromARGB(255, 101, 119, 134)),
                          SizedBox(width: 5),
                          Text(
                            '${formatNumber(widget.tweet.views)}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBookmarked = !isBookmarked;
                                if (isBookmarked) {
                                  widget.tweet.bookmarks++;
                                } else {
                                  widget.tweet.bookmarks--;
                                }
                              });
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
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.share_outlined,
                              size: 16,
                              color: Color.fromARGB(255, 101, 119, 134)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
