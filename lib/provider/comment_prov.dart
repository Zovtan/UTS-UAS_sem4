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


  //hanya mengambil komentar
  Future<void> fetchComments(int twtId) async {
    _setLoadingState(true);
    _setErrorState(false);

    try {
      final response = await http.get(Uri.parse('$baseUrl/$twtId'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body)['comments'] ?? [];
        _comments = jsonList.map((json) => Comment.fromJson(json)).toList();
      } else {
        _setErrorState(true);
      }
    } catch (e) {
      _setErrorState(true);
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
