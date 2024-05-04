import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:twitter/widget/edit_tweet.dart';

class TweetCell extends StatefulWidget {
  final Tweet tweet;
  final int commentCount;
  final String formattedDur;
  final Function(Tweet) onTweetEdited;
  final int currId;
  final Function(int) onDeleteTweet;

  const TweetCell(
      {super.key,
      required this.tweet,
      required this.commentCount,
      required this.formattedDur,
      required this.onTweetEdited,
      required this.currId,
      required this.onDeleteTweet});

  @override
  TweetCellState createState() => TweetCellState();
}

class TweetCellState extends State<TweetCell> {
  @override
  Widget build(BuildContext context) {
    //hitung total tweet
    int ttlRetweets = widget.tweet.retweets + widget.tweet.qtweets;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //kolom 1
        Container(
          //pfp
          width: 35,
          margin: const EdgeInsets.symmetric(horizontal: 5),
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

        //kolom 2
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //nama, waktu dan opsi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis, //jika ada overflow tambal pakai ...
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.tweet.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.tweet.username}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' • ${widget.formattedDur}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 16,
                              ),
                            ),
                          ],
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

                // isi tweet dan image
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

                //icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.tweet.isLiked = !widget.tweet.isLiked;
                          if (widget.tweet.isLiked) {
                            widget.tweet.likes++;
                          } else {
                            widget.tweet.likes--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.tweet.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: widget.tweet.isLiked
                                ? Colors.red
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatNumber(widget.tweet.likes),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.tweet.isRetweeted = !widget.tweet.isRetweeted;
                          if (widget.tweet.isRetweeted) {
                            widget.tweet.retweets++;
                          } else {
                            widget.tweet.retweets--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.tweet.isRetweeted
                                ? Icons.repeat
                                : Icons.repeat_rounded,
                            size: 20,
                            color: widget.tweet.isRetweeted
                                ? Colors.green
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _formatNumber(ttlRetweets),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    //navigasi ke komen
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              tweet: widget.tweet,
                              commentCount: widget.commentCount,
                              currId: widget.currId,
                              formattedDur: widget.formattedDur,
                              formatNumber: _formatNumber,
                              onTweetEdited: widget.onTweetEdited,
                              onDeleteTweet: widget.onDeleteTweet,
                              // Pass update functions
                              onLikePressed: () {
                                setState(() {
                                  widget.tweet.isLiked = !widget.tweet.isLiked;
                                  if (widget.tweet.isLiked) {
                                    widget.tweet.likes++;
                                  } else {
                                    widget.tweet.likes--;
                                  }
                                });
                              },
                              onRetweetPressed: () {
                                setState(() {
                                  widget.tweet.isRetweeted =
                                      !widget.tweet.isRetweeted;
                                  if (widget.tweet.isRetweeted) {
                                    widget.tweet.retweets++;
                                  } else {
                                    widget.tweet.retweets--;
                                  }
                                });
                              },
                              onBookmarkPressed: () {
                                setState(() {
                                  widget.tweet.isBookmarked =
                                      !widget.tweet.isBookmarked;
                                  if (widget.tweet.isBookmarked) {
                                    widget.tweet.bookmarks++;
                                  } else {
                                    widget.tweet.bookmarks--;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.mode_comment_outlined,
                              size: 20,
                              color: Color.fromARGB(255, 101, 119, 134)),
                          const SizedBox(width: 5),
                          Text(
                            _formatNumber(widget.tweet.commentCount),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 101, 119, 134),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.insert_chart_outlined_rounded,
                            size: 20,
                            color: Color.fromARGB(255, 101, 119, 134)),
                        const SizedBox(width: 5),
                        Text(
                          _formatNumber(widget.tweet.views),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 101, 119, 134),
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.tweet.isBookmarked =
                                  !widget.tweet.isBookmarked;
                              if (widget.tweet.isBookmarked) {
                                widget.tweet.bookmarks++;
                              } else {
                                widget.tweet.bookmarks--;
                              }
                            });
                          },
                          child: Icon(
                            widget.tweet.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 20,
                            color: widget.tweet.isBookmarked
                                ? Colors.blue
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.share_outlined,
                            size: 20,
                            color: Color.fromARGB(255, 101, 119, 134)),
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
  }

  //jika ada int yg lbh dari 999 singkatkan
  String _formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      return '${numberInK.toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  void _editTweet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          tweet: widget.tweet,
          onTweetEdited: (editedTweet) {
            widget.onTweetEdited(
                editedTweet); // kirim edited tweet ke mainpage
          },
        ),
      ),
    );
  }
}
