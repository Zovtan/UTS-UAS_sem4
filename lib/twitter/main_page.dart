import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/model/tweets_mdl.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/widget/tweet_cell.dart';
import 'package:twitter/widget/twt_app_bar.dart';
import 'package:twitter/widget/twt_bottom_bar.dart';
import 'package:twitter/widget/add_tweet.dart';

class MainPage extends StatefulWidget {
  final String currUsername;
  final String currDisplayName;

  const MainPage({
    Key? key,
    required this.currUsername,
    required this.currDisplayName,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<TweetProvider>(context, listen: false).fetchTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TwitterBottomBar(),
      body: Consumer<TweetProvider>(
        builder: (context, tweetProvider, child) {
          if (tweetProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (tweetProvider.hasError) {
            return Center(
              child: Text('Failed to load tweets'),
            );
          } else {
            print(tweetProvider.userId);
            return CustomScrollView(
              slivers: [
                TwitterAppBar(currDisplayName: widget.currDisplayName),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.isOdd) {
                        return const Divider(
                          color: Color.fromARGB(120, 101, 119, 134),
                        );
                      } else {
                        int tweetIndex = index ~/ 2;
                        if (tweetIndex < tweetProvider.tweets.length) {
                          TweetMdl tweet = tweetProvider.tweets[tweetIndex];
                          return TweetCell(
                            tweet: tweet,
                            currId: tweetProvider.userId,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                    },
                    childCount: tweetProvider.tweets.length * 2 - 1,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTweetPage(
                currUsername: widget.currUsername,
                currDisplayName: widget.currDisplayName,
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
