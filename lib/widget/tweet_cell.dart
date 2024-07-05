import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/model/tweets_mdl.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/twitter/comment_page.dart';
import 'package:provider/provider.dart';

class TweetCell extends StatelessWidget {
  final TweetMdl tweet;
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
                                  text:
                                      ' • ${tweetProvider.formatDur(parsedTimestamp)}',
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
                    if (tweet.image != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          tweet.image.toString(),
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey,
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey,
                              child:
                                  const Icon(Icons.error, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],

                    // Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            tweetProvider.toggleLike(tweet);
                          },
                          child: Icon(
                            tweet.interactions.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            size: 24,
                            color: tweet.interactions.isLiked
                                ? Colors.red
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                        ),
                        Text(tweet.likes.toString()),
                        GestureDetector(
                          onTap: () {
                            tweetProvider.toggleRetweet(tweet);
                          },
                          child: Icon(
                            Icons.repeat_outlined,
                            size: 24,
                            color: tweet.interactions.isRetweeted
                                ? const Color.fromARGB(255, 0, 186, 124)
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                        ),
                        Text(tweetProvider.formatNumber(ttlRetweets)),
                        GestureDetector(
                          onTap: () {
                            tweetProvider.toggleBookmark(tweet);
                          },
                          child: Icon(
                            tweet.interactions.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined,
                            size: 24,
                            color: tweet.interactions.isBookmarked
                                ? const Color.fromARGB(255, 29, 155, 240)
                                : const Color.fromARGB(255, 101, 119, 134),
                          ),
                        ),
                        Text(tweet.bookmarks.toString()),
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
                        _buildGestureDetector(
                          Icons.insert_chart_outlined_rounded,
                          const Color.fromARGB(255, 101, 119, 134),
                          () {},
                          tweetProvider.formatNumber(tweet.views),
                        ),
                        _buildGestureDetector(
                          Icons.share_outlined,
                          const Color.fromARGB(255, 101, 119, 134),
                          () {},
                          '',
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
    );
  }

  Widget _buildGestureDetector(
      IconData icon, Color color, VoidCallback onTap, String text) {
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
}
