import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/widget/edit_tweet.dart';

class TweetProvider with ChangeNotifier {
  final TweetData _tweetData = TweetData();
  List<Tweet> get tweets => _tweetData.tweets;

  void addTweet(Tweet tweet) {
    _tweetData.addTweet(tweet);
    notifyListeners();
  }

  void updateTweet(Tweet tweet) {
    _tweetData.updateTweet(tweet);
    notifyListeners();
  }

  void deleteTweet(int twtId) {
    _tweetData.deleteTweet(twtId);
    notifyListeners();
  }

  Future<void> countComments(BuildContext context) async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/comments.json');
    List<dynamic> jsonList = jsonDecode(jsonString);

    for (var tweet in _tweetData.tweets) {
      var commentsInTweet = jsonList.firstWhere(
        (comment) => comment['twtId'] == tweet.twtId,
        orElse: () => {'comments': []},
      )['comments'];
      tweet.commentCount = commentsInTweet.length;
    }
    notifyListeners();
  }

// Method to get formatted duration
  String formatDur(DateTime parsedTimestamp) {
    var durTime = DateTime.now().difference(parsedTimestamp);
    if (durTime.inDays > 0) {
      return "${durTime.inDays}d";
    } else if (durTime.inHours > 0) {
      return "${durTime.inHours}h";
    } else if (durTime.inMinutes > 0) {
      return "${durTime.inMinutes}m";
    } else {
      return "Less than a minute";
    }
  }

// Method to get tweet by index
  TweetIm getTweetIm(int index) {
    int tweetIndex = index ~/ 2;
    if (tweetIndex < tweets.length) {
      Tweet tweet = tweets[tweetIndex];
      return TweetIm(tweet: tweet);
    } else {
      throw Exception("Tweet index out of bounds");
    }
  }

  // Method to format number
  String formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      return '${numberInK.toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  // Method to edit tweet
  void editTweet(BuildContext context, Tweet tweet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          tweet: tweet,
          onTweetEdited: (editedTweet) {
            updateTweet(editedTweet); // Update tweet in provider
          },
        ),
      ),
    );
  }

  // Method to toggle like
  void toggleLike(Tweet tweet) {
    tweet.isLiked = !tweet.isLiked;
    if (tweet.isLiked) {
      tweet.likes++;
    } else {
      tweet.likes--;
    }
    updateTweet(tweet); // Update tweet in provider
  }

  // Method to toggle retweet
  void toggleRetweet(Tweet tweet) {
    tweet.isRetweeted = !tweet.isRetweeted;
    if (tweet.isRetweeted) {
      tweet.retweets++;
    } else {
      tweet.retweets--;
    }
    updateTweet(tweet); // Update tweet in provider
  }

  // Method to toggle bookmark
  void toggleBookmark(Tweet tweet) {
    tweet.isBookmarked = !tweet.isBookmarked;
    if (tweet.isBookmarked) {
      tweet.bookmarks++;
    } else {
      tweet.bookmarks--;
    }
    updateTweet(tweet); // Update tweet in provider
  }
}

class TweetIm {
  final Tweet tweet;

  TweetIm({
    required this.tweet,
  });
}
