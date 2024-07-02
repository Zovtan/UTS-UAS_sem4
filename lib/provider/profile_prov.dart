import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twitter/model/profiles_mdl.dart';
import 'package:twitter/twitter/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twitter/twitter/main_page.dart';

class ProfileProvider with ChangeNotifier {
  final String baseUrl =
      'http://10.0.2.2:3031/profile'; // For Android emulator in Visual Studio

  Profile? _profile;
  String? _errorMessage;

  Profile? get profile => _profile;
  String? get errorMessage => _errorMessage;

  Future<void> readProfile(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _profile = Profile.fromJson(responseData['profile']);
        _errorMessage = null;
        notifyListeners();
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> login(
      String identifier, String password, BuildContext context) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/login'), body: {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String token = responseData['token'];
        int userId = responseData['id'];


        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('currUserId', userId);
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              currId: responseData['id'],
              currUsername: responseData['username'],
              currDisplayName: responseData['displayName'],
            ),
          ),
        );
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      String errorMessage = 'Failed to login: $e';
      print(errorMessage); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
        ),
      );
      throw Exception(errorMessage);
    }
  }

  Future<void> register({
    required String username,
    required String displayName,
    required String email,
    required String password,
    required String repeatPassword,
    required BuildContext context,
  }) async {
    try {
      if (password != repeatPassword) {
        throw Exception('Passwords do not match');
      }

      final response = await http.post(Uri.parse('$baseUrl/register'), body: {
        'username': username,
        'displayName': displayName,
        'email': email,
        'password': password,
        'confirmPassword': repeatPassword
      });

      if (response.statusCode == 201) {
        // Update local profile state or navigate to next screen on successful registration
        _profile = Profile(
            username: username,
            displayName: displayName,
            email: email,
            password: password);

        // Example of navigating to login screen after successful registration
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
        ),
      );
      throw Exception('Failed to register: $e');
    }
  }
}
