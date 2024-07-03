import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:twitter/model/tweets_mdl.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/provider/comment_prov.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final TweetMdl tweet;
  final int? currId;

  const CommentPage({
    Key? key,
    required this.tweet,
    required this.currId,
  }) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    super.initState();
    // Fetch comments when the page is initialized
    Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.tweet.twtId);
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
                      if (widget.tweet.image != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.tweet.image.toString(),
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],

                      // Info
                      Consumer<TweetProvider>(
                        builder: (context, TweetProvider, _) {
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
                                            text: TweetProvider.formatNumber(
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
                                                '${TweetProvider.formatNumber(widget.tweet.retweets)} ',
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
                                                '  ${TweetProvider.formatNumber(widget.tweet.qtweets)} ',
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
                                                '  ${TweetProvider.formatNumber(widget.tweet.likes)} ',
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
                                                '  ${TweetProvider.formatNumber(widget.tweet.bookmarks)} ',
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
                      /* Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.mode_comment_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 101, 119, 134)),
                              const Icon(Icons.share_outlined,
                                  size: 24,
                                  color: Color.fromARGB(255, 101, 119, 134)),
                              IconButton(
                                icon: Icon(
                                  widget.tweet.isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: widget.tweet.isBookmarked
                                      ? Colors.blue
                                      : Color.fromARGB(255, 101, 119, 134),
                                ),
                                onPressed: () {
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .toggleBookmark(widget.tweet.twtId);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  widget.tweet.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.tweet.isLiked
                                      ? Colors.red
                                      : Color.fromARGB(255, 101, 119, 134),
                                ),
                                onPressed: () {
                                  Provider.of<TweetProvider>(context,
                                          listen: false)
                                      .toggleLike(widget.tweet.twtId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ), */
                      const SizedBox(height: 7),
                      const Divider(
                        color: Color.fromARGB(120, 101, 119, 134),
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Comments (second row)
            const SizedBox(height: 10),
            Consumer<CommentProvider>(
              builder: (context, commentProvider, _) {
                if (commentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (commentProvider.comments.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commentProvider.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentProvider.comments[index];
                      return ListTile(
                        leading: ProfilePicture(
                          name: comment.displayName,
                          radius: 18,
                          fontsize: 10,
                          count: 2,
                        ),
                        title: Text(comment.displayName),
                        subtitle: Text(comment.comment),
                        trailing: Text(DateFormat('h:mm a • dd MMM yy')
                            .format(DateTime.parse(widget.tweet.timestamp))),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
