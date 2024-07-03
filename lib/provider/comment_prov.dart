import 'package:flutter/foundation.dart';
import 'package:twitter/model/comment_mdl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentProvider with ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:3031/tweets/comments';

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<void> fetchComments(int twtId) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.get(Uri.parse('$baseUrl/$twtId'));
      print('$baseUrl/$twtId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['comments'] ?? [];
        _comments = jsonList.map((json) => Comment.fromJson(json)).toList();
      } else {
        _setErrorState(true);
        print('Error fetching comments: ${response.statusCode}');
      }
    } catch (e) {
      _setErrorState(true);
      print('Error fetching comments: $e');
    } finally {
      _setLoadingState(false);
    }
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
