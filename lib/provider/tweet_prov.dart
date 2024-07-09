import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter/model/tweets_mdl.dart';
import 'package:twitter/widget/edit_tweet.dart';

class TweetProvider with ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:3031/tweets';

  List<TweetMdl> _tweets = [];
  List<TweetMdl> get tweets => _tweets;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  int _userId = 0; // id default
  int get userId => _userId;

  TweetProvider() {
    fetchTweets(); // Inisialisasi ketika provider dimuat
  }

  //mengambil userId dari SharedPreferences
  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('currUserId') ?? 0;
    notifyListeners();
  }

// mengambil tweet dari server, userId dibutuhkan utk mengecek interaksi
  Future<void> fetchTweets() async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      await fetchUserId();

      final response = await http.get(
        Uri.parse('$baseUrl/$_userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['tweets'] ?? [];
        _tweets = jsonList.map((json) => TweetMdl.fromJson(json)).toList();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  //fungsi tambah tweet
  Future<void> addTweet(String tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      await fetchUserId();
      final response = await http.post(
        Uri.parse('$baseUrl/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId, 'tweet': tweet}),
      );
      if (response.statusCode == 201) {
        await fetchTweets();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  //fungsi ubah isi tweet
  Future<void> updateTweet(int twtId, String tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      await fetchUserId();
      final response = await http.patch(
        Uri.parse('$baseUrl/$twtId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId, 'tweet': tweet}),
      );
      if (response.statusCode == 200) {
        await fetchTweets();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  void editTweet(
      BuildContext context, String currDisplayName, int twtId, String tweet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          currDisplayName: currDisplayName,
          tweet: tweet,
          onTweetEdited: (editedTweet) {
            updateTweet(
                twtId, editedTweet); // Pass editedTweet instead of tweet
          },
        ),
      ),
    );
  }

  //fungsi hapus tweet
  Future<bool> deleteTweet(int twtId) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      await fetchUserId();
      final response = await http.delete(
        Uri.parse('$baseUrl/$twtId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      if (response.statusCode == 200) {
        await fetchTweets();
        return true;
      } else {
        _setErrorState(true);
        return false;
      }
    } catch (e) {
      _setErrorState(true);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

//fungsi toggle like, retweet, dan bookmark. Ada versi lokal agar setiap kali di tekan tidak refresh 1 halaman, tapi masi tetap upload interaksi
  Future<void> toggleLike(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/like/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      if (response.statusCode == 200) {
        tweet.interactions.isLiked = !tweet.interactions.isLiked;
        if (tweet.interactions.isLiked) {
          tweet.likes++;
        } else {
          tweet.likes--;
        }
        notifyListeners();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> toggleRetweet(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/retweet/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      if (response.statusCode == 200) {
        tweet.interactions.isRetweeted = !tweet.interactions.isRetweeted;
        if (tweet.interactions.isRetweeted) {
          tweet.retweets++;
        } else {
          tweet.retweets--;
        }
        notifyListeners();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> toggleBookmark(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookmark/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
      );
      if (response.statusCode == 200) {
        tweet.interactions.isBookmarked = !tweet.interactions.isBookmarked;
        if (tweet.interactions.isBookmarked) {
          tweet.bookmarks++;
        } else {
          tweet.bookmarks--;
        }
        notifyListeners();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  //fungsi formating time stamp dan format Int
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

  String formatNumber(int number) {
    if (number >= 1000) {
      double numberInK = number / 1000;
      return '${numberInK.toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }

  //loading dan error state
  void _setLoadingState(bool state) {
    _isLoading = state;
    if (state == false) {
      notifyListeners();
    }
  }

  void _setErrorState(bool state) {
    _hasError = state;
    if (state == true) {
      notifyListeners();
    }
  }
}
