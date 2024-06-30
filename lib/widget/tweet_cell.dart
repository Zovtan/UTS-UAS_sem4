import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:provider/provider.dart';

class TweetCell extends StatelessWidget {
  final Tweet tweet;
  final int? currId;

  const TweetCell({
    Key? key,
    required this.tweet,
    required this.currId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TweetProvider>(
      builder: (context, tweetProvider, _) {
        // Calculate total retweets
        int ttlRetweets = tweet.retweets + tweet.qtweets;
        DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column 1: Profile Picture
            Container(
              width: 35,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePicture(
                    name: tweet.displayName,
                    radius: 18,
                    fontsize: 10,
                    count: 2,
                  ),
                ],
              ),
            ),

            // Column 2: Tweet Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, username, and options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: tweet.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${tweet.username}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 101, 119, 134),
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: ' • ${tweetProvider.formatDur(parsedTimestamp)}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 101, 119, 134),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Display menu only if tweet belongs to current user
                        if (tweet.userId == currId)
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
                                tweetProvider.editTweet(context, tweet);
                              } else if (value == 'Delete') {
                                tweetProvider.deleteTweet(tweet.twtId);
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
                      tweet.tweet,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    if (tweet.image != "none") ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(tweet.image),
                      ),
                      const SizedBox(height: 5),
                    ],

                    // Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGestureDetector(
                          tweet.isLiked ? Icons.favorite : Icons.favorite_border,
                          tweet.isLiked ? Colors.red : const Color.fromARGB(255, 101, 119, 134),
                          () {
                            tweetProvider.toggleLike(tweet);
                          },
                          tweetProvider.formatNumber(tweet.likes),
                        ),
                        _buildGestureDetector(
                          tweet.isRetweeted ? Icons.repeat : Icons.repeat_rounded,
                          tweet.isRetweeted ? Colors.green : const Color.fromARGB(255, 101, 119, 134),
                          () {
                            tweetProvider.toggleRetweet(tweet);
                          },
                          tweetProvider.formatNumber(ttlRetweets),
                        ),
                        _buildGestureDetector(
                          Icons.mode_comment_outlined,
                          const Color.fromARGB(255, 101, 119, 134),
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentPage(
                                  tweet: tweet,
                                  currId: currId,
                                ),
                              ),
                            );
                          },
                          tweetProvider.formatNumber(tweet.commentCount),
                        ),
                        _buildIcon(Icons.insert_chart_outlined_rounded, tweetProvider.formatNumber(tweet.views)),
                        _buildGestureDetector(
                          tweet.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          tweet.isBookmarked ? Colors.blue : const Color.fromARGB(255, 101, 119, 134),
                          () {
                            tweetProvider.toggleBookmark(tweet);
                          },
                          '',
                        ),
                        _buildIcon(Icons.share_outlined, ''),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildGestureDetector(IconData icon, Color color, VoidCallback onTap, String text) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Color.fromARGB(255, 101, 119, 134),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color.fromARGB(255, 101, 119, 134),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 101, 119, 134),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
