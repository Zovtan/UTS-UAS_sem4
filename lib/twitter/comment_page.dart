import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitter/model/tweets_mdl.dart';
import 'package:twitter/model/comment_mdl.dart';
import 'package:twitter/provider/comment_prov.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/widget/comment_section.dart';

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
  List<Comment> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    await Provider.of<CommentProvider>(context, listen: false)
        .fetchComments(widget.tweet.twtId);
    setState(() {
      comments = Provider.of<CommentProvider>(context, listen: false).comments;
      isLoading = false;
    });
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              color: Color.fromARGB(
                                                  255, 101, 119, 134),
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
                            if (widget.tweet.image == null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  width: double
                                      .infinity, // You can set the desired width
                                  height: 200, // Set the desired height
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ] else if (widget.tweet.image == "none") ...[
                              const SizedBox(height: 5),
                            ] else ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                    widget.tweet.image.toString()),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '$formattedTimestamp • ',
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 101, 119, 134),
                                                      fontSize: 16),
                                                ),
                                                TextSpan(
                                                  text: TweetProvider
                                                      .formatNumber(
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                            Column(
                              children: [
                                Consumer<TweetProvider>(
                                    builder: (context, tweetProvider, _) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.mode_comment_outlined,
                                          size: 24,
                                          color: Color.fromARGB(
                                              255, 101, 119, 134)),
                                      GestureDetector(
                                        onTap: () {
                                          tweetProvider
                                              .toggleLike(widget.tweet);
                                        },
                                        child: Icon(
                                          widget.tweet.interactions.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          size: 24,
                                          color:
                                              widget.tweet.interactions.isLiked
                                                  ? Colors.red
                                                  : const Color.fromARGB(
                                                      255, 101, 119, 134),
                                        ),
                                      ),
                                      Text(widget.tweet.likes.toString()),
                                      GestureDetector(
                                        onTap: () {
                                          tweetProvider
                                              .toggleRetweet(widget.tweet);
                                        },
                                        child: Icon(
                                          Icons.repeat_outlined,
                                          size: 24,
                                          color: widget.tweet.interactions
                                                  .isRetweeted
                                              ? const Color.fromARGB(
                                                  255, 0, 186, 124)
                                              : const Color.fromARGB(
                                                  255, 101, 119, 134),
                                        ),
                                      ),
                                      Text(widget.tweet.retweets.toString()),
                                      GestureDetector(
                                        onTap: () {
                                          tweetProvider
                                              .toggleBookmark(widget.tweet);
                                        },
                                        child: Icon(
                                          widget.tweet.interactions.isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border_outlined,
                                          size: 24,
                                          color: widget.tweet.interactions
                                                  .isBookmarked
                                              ? const Color.fromARGB(
                                                  255, 29, 155, 240)
                                              : const Color.fromARGB(
                                                  255, 101, 119, 134),
                                        ),
                                      ),
                                      Text(widget.tweet.bookmarks.toString()),
                                      /* GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isRetweeted = !isRetweeted;
                                            });
                                            Provider.of<TweetProvider>(context,
                                                    listen: false)
                                                .toggleRetweet(
                                                    widget.tweet.twtId,
                                                    widget.currId,
                                                    isRetweeted);
                                          },
                                          child: Icon(
                                            Icons.repeat_outlined,
                                            size: 24,
                                            color: isRetweeted
                                                ? const Color.fromARGB(
                                                    255, 0, 186, 124)
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
                                                .toggleLike(widget.tweet.twtId,
                                                    widget.currId, isLiked);
                                          },
                                          child: Icon(
                                            isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border_outlined,
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
                                                .toggleBookmark(
                                                    widget.tweet.twtId,
                                                    widget.currId,
                                                    isBookmarked);
                                          },
                                          child: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_border_outlined,
                                            size: 24,
                                            color: isBookmarked
                                                ? const Color.fromARGB(
                                                    255, 29, 155, 240)
                                                : const Color.fromARGB(
                                                    255, 101, 119, 134),
                                          ),
                                        ), */
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Comments (second row)
                  CommentsSection(
                    comments: comments,
                    parsedTimestamp: parsedTimestamp,
                  ),
                ],
              ),
            ),
    );
  }
}
