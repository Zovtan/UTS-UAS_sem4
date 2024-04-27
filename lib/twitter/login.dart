import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:twitter/twitter/main_page.dart';
import 'package:twitter/twitter/sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class Profile {
  final int id;
  final String username;
  final String displayName;
  final String password;
  final String email;
  final String phone;

  Profile(
      {required this.id,
      required this.username,
      required this.displayName,
      required this.password,
      required this.email,
      required this.phone});

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

//state awal visible
bool _passwordVisible = false;
//di luar karna kalo di dalam build bakal ke reset sama visibility password
final TextEditingController _identifierController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
//reset id user
int _userId = 0;

//harus initState supaya kerestart saat keluar dari aplikasi. Kalau g variable di ingat app. ntah kenapa harus diluar class _loginState
@override
void initState() {
  _passwordVisible;
  _identifierController;
  _passwordController;
  _userId;
}

class _LoginState extends State<Login> {
  List<Profile> profiles = [];

  @override
  void initState() {
    super.initState();
    _checkProfile(); // Call the method to count comments
  }

  Future<void> _checkProfile() async {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            body: Column(
              children: [
                TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone Number, Username, or Email",
                  ),
                ),
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                //tombol login
                ElevatedButton(
                  onPressed: () {
                    // Validation logic
                    bool isValid = false;
                    for (var profile in profiles) {
                      if ((profile.email ==
                                  _identifierController.text
                                      .replaceAll(RegExp(r"\s+"), "") ||
                              profile.displayName ==
                                  _identifierController.text
                                      .replaceAll(RegExp(r"\s+"), "") ||
                              profile.phone ==
                                  _identifierController.text
                                      .replaceAll(RegExp(r"\s+"), "")) &&
                          profile.password ==
                              _passwordController.text
                                  .replaceAll(RegExp(r"\s+"), "")) {
                        isValid = true;
                        _userId = profile.id;
                        break;
                      }
                    }

                    if (isValid) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(userId: _userId),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email atau password salah'),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                //tombol sign in
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                    child: const Text('Sign In'))
              ],
            ),
          );
        }
      },
    );
  }
}
