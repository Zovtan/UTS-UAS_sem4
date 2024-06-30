import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/widget/tweet_cell.dart';
import 'package:twitter/widget/twt_app_bar.dart';
import 'package:twitter/widget/twt_bottom_bar.dart';
import 'package:twitter/widget/add_tweet.dart';

class MainPage extends StatelessWidget {
  final int? currId;
  final String currUsername;
  final String currDisplayName;

  const MainPage({
    Key? key,
    required this.currId,
    required this.currUsername,
    required this.currDisplayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TwitterBottomBar(),
      body: CustomScrollView(
        slivers: [
          TwitterAppBar(currDisplayName: currDisplayName),
          Consumer<TweetProvider>(
            builder: (context, tweetProvider, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index.isOdd) {
                      return const Divider(
                        color: Color.fromARGB(120, 101, 119, 134),
                      );
                    } else {
                      try {
                        TweetIm tweetIm =
                            tweetProvider.getTweetIm(index);
                        return TweetCell(
                          tweet: tweetIm.tweet,
                          currId: currId,
                        );
                      } catch (e) {
                        return const SizedBox();
                      }
                    }
                  },
                  childCount: tweetProvider.tweets.length * 2 - 1,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTweetPage(
                onTweetAdded: (newTweet) {
                  Provider.of<TweetProvider>(context, listen: false)
                      .addTweet(Tweet(
                    twtId: Provider.of<TweetProvider>(context, listen: false)
                            .tweets
                            .length +
                        1,
                    userId: currId ?? 0,
                    username: currUsername,
                    displayName: currDisplayName,
                    tweet: newTweet,
                    image: "none",
                    timestamp: DateTime.now().toIso8601String(),
                    likes: 0,
                    retweets: 0,
                    qtweets: 0,
                    views: 0,
                    bookmarks: 0,
                    commentCount: 0,
                  ));
                },
                currDisplayName: currDisplayName,
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
