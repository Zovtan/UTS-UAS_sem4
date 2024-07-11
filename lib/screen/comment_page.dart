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
    super.key,
    required this.tweet,
    required this.currId,
  });

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
                            Consumer<TweetProvider>(
                              builder: (context, tweetProvider, _) {
                                return Row(
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
                                            tweetProvider.editTweetNav(
                                                context,
                                                widget.tweet.displayName,
                                                widget.tweet.twtId,
                                                widget.tweet.tweet);
                                          } else if (value == 'Delete') {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Delete Tweet'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this tweet?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        tweetProvider
                                                            .deleteTweet(
                                                                widget.tweet.twtId)
                                                            .then((success) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(success
                                                                  ? 'Tweet deleted successfully'
                                                                  : 'Failed to delete tweet'),
                                                            ),
                                                          );
                                                        });
                                                      },
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Color.fromARGB(255, 101, 119, 134),
                                          size: 15,
                                        ),
                                      ),
                                  ],
                                );
                              }
                            ),

                            // Tweet text and image
                            const SizedBox(height: 5),
                            Text(
                              widget.tweet.tweet,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            //gambar akan menunjukkan petak abu ketika loading dan tdk muncul jika tdk ada
                            if (widget.tweet.image != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  widget.tweet.image.toString(),
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
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
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey,
                                      child: const Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                  },
                                ),
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
                                                  text: tweetProvider
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
                                          Expanded(
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: double.infinity),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${tweetProvider.formatNumber(widget.tweet.retweets)} ',
                                                    ),
                                                    const TextSpan(
                                                      text: 'Reposts ',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 101, 119, 134),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${tweetProvider.formatNumber(widget.tweet.qtweets)} ',
                                                    ),
                                                    const TextSpan(
                                                      text: 'Quotes ',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 101, 119, 134),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${tweetProvider.formatNumber(widget.tweet.likes)} ',
                                                    ),
                                                    const TextSpan(
                                                      text: 'Likes ',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 101, 119, 134),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${tweetProvider.formatNumber(widget.tweet.bookmarks)} ',
                                                    ),
                                                    const TextSpan(
                                                      text: 'Bookmarks',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 101, 119, 134),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
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
                                      _buildGestureDetector(
                                        Icons.mode_comment_outlined,
                                        const Color.fromARGB(
                                            255, 101, 119, 134),
                                        () {},
                                      ),
                                      _buildGestureDetector(
                                          widget.tweet.interactions.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          widget.tweet.interactions.isLiked
                                              ? Colors.red
                                              : const Color.fromARGB(
                                                  255, 101, 119, 134),
                                          () => tweetProvider
                                              .toggleLike(widget.tweet)),
                                      _buildGestureDetector(
                                          Icons.repeat_outlined,
                                          widget.tweet.interactions.isRetweeted
                                              ? const Color.fromARGB(
                                                  255, 0, 186, 124)
                                              : const Color.fromARGB(
                                                  255, 101, 119, 134),
                                          () => tweetProvider
                                              .toggleRetweet(widget.tweet)),
                                      _buildGestureDetector(
                                          widget.tweet.interactions.isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border_outlined,
                                          widget.tweet.interactions.isBookmarked
                                              ? const Color.fromARGB(
                                                  255, 29, 155, 240)
                                              : const Color.fromARGB(
                                                  255, 101, 119, 134),
                                          () => tweetProvider
                                              .toggleBookmark(widget.tweet)),
                                      _buildGestureDetector(
                                        Icons.share_outlined,
                                        const Color.fromARGB(
                                            255, 101, 119, 134),
                                        () {},
                                      ),
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

  //ikon custom
  Widget _buildGestureDetector(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
        ],
      ),
    );
  }
}
