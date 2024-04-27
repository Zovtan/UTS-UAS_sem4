import 'package:flutter/material.dart';
import 'dart:convert';

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
}

class _SignInState extends State<SignIn> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  // Check if the provided email already exists
  bool isEmailExist(String email) {
    return profiles.any((Profile) => Profile.email == email);
  }

  // Check if the provided username already exists
  bool isUsernameExist(String username) {
    return profiles.any((Profile) => Profile.username == username);
  }

  // Check if the provided phone number already exists
  bool isPhoneExist(String phone) {
    return profiles.any((Profile) => Profile.phone == phone);
  }

  // Handle sign-in button press
  void signIn() {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    // Check for duplicates
    if (isUsernameExist(username)) {
      // Username already exists
      // Show error message or handle accordingly
      return;
    }
    if (isEmailExist(email)) {
      // Email already exists
      // Show error message or handle accordingly
      return;
    }
    if (isPhoneExist(phone)) {
      // Phone number already exists
      // Show error message or handle accordingly
      return;
    }

    // All fields are unique, proceed with sign-in
    // You can add your sign-in logic here
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
            ElevatedButton(
              onPressed: signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
