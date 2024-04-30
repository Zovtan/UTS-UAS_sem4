import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/twitter/comment_page.dart';

class TweetCell extends StatelessWidget {
  final Tweet tweet;
  final int commentCount;

  const TweetCell({
    Key? key,
    required this.tweet,
    required this.commentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
    String formattedTimestamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTimestamp);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommentPage(
              tweetId: tweet.id,
              username: tweet.username,
              displayName: tweet.displayName,
              tweet: tweet.tweet,
              image: tweet.image,
              timestamp: formattedTimestamp,
              likes: tweet.likes,
              retweets: tweet.retweets,
              commentCount: commentCount,
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column
          Container(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePicture(
                  name: tweet.displayName,
                  radius: 18,
                  fontsize: 10,
                  random: true,
                  count: 2,
                ),
              ],
            ),
          ),

          // Right column
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: tweet.displayName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " " + tweet.username,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(tweet.tweet),
                  SizedBox(height: 5),
                  if (tweet.image != "none") ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(tweet.image),
                    ),
                    SizedBox(height: 5),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mode_comment_outlined,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            '${tweet.commentCount}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.repeat_rounded,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            '${tweet.retweets}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite_border,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            '${tweet.likes}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.insert_chart_outlined_rounded,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            '${tweet.likes + 230}',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Icon(Icons.bookmark_outline,
                          size: 16, color: Colors.grey),
                      Icon(Icons.share_outlined, size: 16, color: Colors.grey),
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
