import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:twitter/twitter/login.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class Profile {
  final int id;
  final String username;
  final String displayName;
  final String password;
  final String email;
  final String phone;

  Profile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.password,
    required this.email,
    required this.phone,
  });

  // Convert JSON to Profile object
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'password': password,
      'email': email,
      'phone': phone,
    };
  }
}

final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

@override
void initState() {
  usernameController;
  emailController;
  phoneController;
}


class _SignInState extends State<SignIn> {
  // List to hold profiles from JSON
  late List<Profile> profiles;

  // Load profiles from JSON
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load profiles from JSON file
  void _loadUsers() async {
    // Read the JSON file
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/json/profiles.json');
    // Parse JSON
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Populate the list of tweets
    setState(() {
      profiles = jsonList.map((json) => Profile.fromJson(json)).toList();
    });
  }

  // Check if the provided email, username, phone num already exists
  bool _isEmailExist(String email) {
    return profiles.any((Profile) => Profile.email == email);
  }

  bool _isUsernameExist(String username) {
    return profiles.any((Profile) => Profile.username == username);
  }

  bool _isPhoneExist(String phone) {
    return profiles.any((Profile) => Profile.phone == phone);
  }

  // Handle sign-in button press
  _signInHandling() {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    // Check for duplicates
    if (!_isUsernameExist(username) ||
        !_isEmailExist(email) ||
        !_isPhoneExist(phone)) {
      Profile newProfile = Profile(
        id: 5, // You may assign an ID as needed
        username: username,
        displayName: '', // Set to empty string for now
        password: '', // Set to empty string for now
        email: email,
        phone: phone,
      );

      // Write the profile data to JSON file
      _writeToJson(newProfile);
    }
  }
  
Future<void> _writeToJson(Profile profile) async {
  try {
    // Load existing JSON data from file
    String jsonString = await rootBundle.loadString('data/profiles.json');
    List<dynamic> jsonList = jsonDecode(jsonString);

    // Add the new profile data to the list
    jsonList.add(profile.toJson());

    // Convert the updated list back to JSON
    String updatedJsonString = jsonEncode(jsonList);

    // Write the updated JSON data back to the file
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/profiles.json');
    await file.writeAsString(updatedJsonString);

    print('Data written to JSON file successfully.');
  } catch (e) {
    print('Error writing to JSON file: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            SizedBox(height: 20),
            //sign in button
            ElevatedButton(
              onPressed: _signInHandling,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
