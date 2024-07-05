import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:twitter/model/comment_mdl.dart';
import 'package:twitter/provider/comment_prov.dart';
import 'package:twitter/provider/tweet_prov.dart';

class CommentsSection extends StatelessWidget {
  final List<Comment> comments;
  final DateTime parsedTimestamp;

  const CommentsSection({
    Key? key,
    required this.comments,
    required this.parsedTimestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, _) {
        if (commentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (commentProvider.comments.isEmpty) {
          return const Center(child: Text('No comments yet.'));
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: commentProvider.comments.length,
              itemBuilder: (BuildContext context, int index) {
                Comment comment = commentProvider.comments[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1
                    // Profile picture
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

                    // Name and duration
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
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
                                              color: Color.fromARGB(255, 101, 119, 134),
                                              fontSize: 16),
                                        ),
                                        TextSpan(
                                          text: ' • ${Provider.of<TweetProvider>(context, listen: false).formatDur(parsedTimestamp)}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 101, 119, 134),
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Comment text
                            const SizedBox(height: 5),
                            Text(
                              comment.comment,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),

                            // Icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '0',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 101, 119, 134),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.repeat_rounded,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '0',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 101, 119, 134),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.mode_comment_outlined,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '0',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 101, 119, 134),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.insert_chart_outlined_rounded,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '0',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 101, 119, 134),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.bookmark_border,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.share_outlined,
                                      size: 20,
                                      color: Color.fromARGB(255, 101, 119, 134),
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
          );
        }
      },
    );
  }
}
