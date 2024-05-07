import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/widget/tweet_cell.dart';
import 'package:twitter/widget/twt_app_bar.dart';
import 'package:twitter/widget/twt_bottom_bar.dart';
import 'package:twitter/widget/add_tweet.dart';
import 'package:twitter/class/profiles.dart';

class MainPage extends StatefulWidget {
  final int currId;
  final String currUsername;
  final String currDisplayName;
  final ProfileData profileData;

  const MainPage(
      {super.key,
      required this.currId,
      required this.currUsername,
      required this.currDisplayName,
      required this.profileData});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TweetData tweetData = TweetData();
  late ProfileData profileData;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    _countComments();
    profileData = widget.profileData; // refresh data profil supaya appbar mendapatkan data terbaru
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const TwitterBottomBar(),
      body: CustomScrollView(
        slivers: [
          TwitterAppBar(
            currDisplayName: widget.currDisplayName,
            profileData: profileData,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: tweetData.tweets.length * 2 - 1, //menggandakan jumlah tweet
              (BuildContext context, int index) {
                //setiap tweet dgn index ganjil di ganti dgn divider
                //supaya semua tweet bisa muncul maka jumlah tweet digandakan. 
                //jika ada tweet ganda yg belum dihapus tersisa maka akan dihapus
                if (index.isOdd) {
                  return const Divider(
                    color: Color.fromARGB(120, 101, 119, 134),
                  );
                } else {
                  int tweetIndex = index ~/ 2;
                  if (tweetIndex < tweetData.tweets.length) {
                    Tweet tweet = tweetData.tweets[tweetIndex];
                    //buat string bisa dibaca jadi datetime
                    DateTime parsedTimestamp = DateTime.parse(tweet.timestamp);
                    //hitung selisih waktu
                    var durTime = DateTime.now().difference(parsedTimestamp);
                    String formattedDur;
                    if (durTime.inDays > 0) {
                      formattedDur = "${durTime.inDays}d";
                    } else if (durTime.inHours > 0) {
                      formattedDur = "${durTime.inHours}h";
                    } else if (durTime.inMinutes > 0) {
                      formattedDur = "${durTime.inMinutes}m";
                    } else {
                      formattedDur = "Less than a minute";
                    }
                    return TweetCell(
                      tweet: tweet,
                      commentCount:
                      tweet.commentCount,
                      formattedDur: formattedDur,
                      onTweetEdited: _editTweet,
                      onDeleteTweet: _deleteTweet,
                      currId: widget.currId,
                    );
                  } else {
                    return const SizedBox(); //kirim widget kosong jika tweet habis
                  }
                }
              },
            ),
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
                //terima newTweet dan setState agar dapat muncul di page
                onTweetAdded: (newTweet) {
                  setState(() {
                    tweetData.addTweet(Tweet(
                      twtId: tweetData.tweets.length + 1,
                      userId: widget.currId,
                      username: widget.currUsername,
                      displayName: widget.currDisplayName,
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
                  });
                },
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

  //Hitung komen dalam json komen lalu kirim kesini
  Future<void> _countComments() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      for (var tweet in tweetData.tweets) {
        // cari komen utk tweet
        var commentsInTweet = jsonList.firstWhere(
          (comment) => comment['twtId'] == tweet.twtId,
          orElse: () =>
              {'comments': []}, // jika tdk ada komen kosongkan
        )['comments'];
        // udpate tweetcount
        tweet.commentCount = commentsInTweet.length;
      }
    });
  }

  //panggil fungsi update dan delete
  void _editTweet(Tweet editedTweet) {
    setState(() {
      tweetData.updateTweet(editedTweet);
    });
  }

  void _deleteTweet(int twtId) {
    setState(() {
      tweetData.deleteTweet(twtId);
    });
  }
}
