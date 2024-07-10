import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twitter/twitter/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter/twitter/main_page.dart';

class ProfileProvider with ChangeNotifier {
  final String baseUrl =
      'http://10.0.2.2:3031/profile'; // 10.0.2.2 agarlocalhost dpt konek ke emulator vscode

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  //fungsi login. identifier dapat menggunakan email/username
  Future<void> login(
      String identifier, String password, BuildContext context) async {
    _setLoading(true);
    try {
      final response = await http.post(Uri.parse('$baseUrl/login'), body: {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        int userId = responseData['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Clear shared preferences
        await prefs.setInt('currUserId', userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              currUsername: responseData['username'],
              currDisplayName: responseData['displayName'],
            ),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message']);
      }
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  //fungsi registrasi
  Future<void> register({
    required String username,
    required String displayName,
    required String email,
    required String password,
    required String repeatPassword,
    required BuildContext context,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(Uri.parse('$baseUrl/register'), body: {
        'username': username,
        'displayName': displayName,
        'email': email,
        'password': password,
        'confirmPassword': repeatPassword
      });

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        throw Exception(responseData['message']);
      }
    } catch (e) {
      _errorMessage = e.toString();
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  //loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
