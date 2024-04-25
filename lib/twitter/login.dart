import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:twitter/twitter/main_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class Profile {
  final int id;
  final String author;
  final String username;
  final String password;
  final String email;
  final String phone;

  Profile(
      {required this.id,
      required this.author,
      required this.username,
      required this.password,
      required this.email,
      required this.phone});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id'],
        author: json['author'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        phone: json['phone']);
  }
}

//state awal visible
bool _passwordVisible = false;
/*   void initState() {
  _passwordVisible = false;
} */
//di luar karna kalo di dalam build bakal ke reset sama visibility password
final TextEditingController _emailController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
//reset id user
int userId = 0;

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
    return Scaffold(
        body: Column(
      children: [
        TextField(
            keyboardType: TextInputType.text,
            controller: _emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone Number, Username, or Email")),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: _passwordController,
          obscureText: !_passwordVisible, //This will obscure text dynamically
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            // Here is key idea
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            //validitas login
bool isValid = false;
            for (var profile in profiles) {
              if (profile.email == _emailController.text &&
                  profile.password == _passwordController.text) {
                isValid = true;
                userId = profile.id;
                break;
              }
            }

            if (isValid) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(
                          idUser: userId,
                        )),
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
        )
      ],
    ));
  }
}
