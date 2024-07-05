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

  int _userId = 0; // Class-level variable to store userId
  int get userId => _userId; // Getter for userId

  TweetProvider() {
    fetchTweets(); // Initial fetch when provider is created
  }

  // Method to fetch userId from SharedPreferences
  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('currUserId') ?? 0;
    notifyListeners(); // Notify listeners after updating userId
  }

// Fetch tweets from the server
  Future<void> fetchTweets() async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      if (_userId == 0) {
        await fetchUserId(); // Ensure userId is fetched before making the request
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$_userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['tweets'] ?? [];
        _tweets = jsonList.map((json) => TweetMdl.fromJson(json)).toList();
      } else {
        _setErrorState(true);
        print('Error fetching tweets: ${response.statusCode}');
      }
    } catch (e) {
      _setErrorState(true);
      print('Error fetching tweets: $e');
    } finally {
      _setLoadingState(false);
    }
  }


  Future<void> addTweet(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tweet.toJson()),
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

  Future<void> updateTweet(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tweet.toJson()),
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

  Future<void> deleteTweet(int twtId) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.delete(Uri.parse('$baseUrl/$twtId'));
      if (response.statusCode == 200) {
        _tweets.removeWhere((tweet) => tweet.twtId == twtId);
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> toggleLike(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      if (_userId == 0) {
        await fetchUserId(); // Ensure userId is fetched before making the request
      }

      final response = await http.post(
        Uri.parse('$baseUrl/like/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
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

  Future<void> toggleRetweet(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      if (_userId == 0) {
        await fetchUserId(); // Ensure userId is fetched before making the request
      }
      final response = await http.post(
        Uri.parse('$baseUrl/retweet/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
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

  Future<void> toggleBookmark(TweetMdl tweet) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      if (_userId == 0) {
        await fetchUserId(); // Ensure userId is fetched before making the request
      }
      final response = await http.post(
        Uri.parse('$baseUrl/bookmark/${tweet.twtId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': _userId}),
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

  void editTweet(BuildContext context, TweetMdl tweet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTweetPage(
          tweet: tweet,
          onTweetEdited: (editedTweet) {
            updateTweet(editedTweet);
          },
        ),
      ),
    );
  }

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
