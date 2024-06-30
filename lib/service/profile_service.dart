import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:twitter/model/profiles_mdl.dart';

class ProfileService {
  final String baseUrl = 'http://your-api-url.com';

  Future<Profile> readProfile(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/profile/$id'));

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body)['profile']);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<String> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': identifier,
        'username': identifier,
        'phone': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(Profile profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }
}
