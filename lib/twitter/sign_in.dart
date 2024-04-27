import 'package:flutter/material.dart';
import 'package:twitter/class/profiles.dart';
import 'package:twitter/twitter/main_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final ProfileData profileData = ProfileData();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String currUsername = "";
  String currDisplayname = "";

  @override
  void initState() {
    super.initState();
    usernameController;
    displayNameController;
    emailController;
    phoneController;
    passwordController;
    currUsername = "";
    currDisplayname = "";
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
              controller: displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
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
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),

            SizedBox(height: 20),
            //sign in button
            ElevatedButton(
              onPressed: () {
                // Validation logic
                bool isValid = true; // Set isValid to true initially

                String email = emailController.text.trim().toLowerCase();
                String username = usernameController.text.trim();
                String phone = phoneController.text.trim();

                for (var profile in profileData.profiles) {
                  if (profile.email == email ||
                      profile.username == username ||
                      profile.phone == phone) {
                    isValid =
                        false; // Toggle isValid to false if a match is found
                    break;
                  }
                }

                if (isValid) {
                  // If isValid is still true, it means no match was found, so proceed with the action
                  currUsername = username;
                  currDisplayname = displayNameController.text.trim();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(
                        currUsername: currUsername,
                        currDisplayName: currDisplayname,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  // If isValid is false, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Email, username, or Phone number is taken'),
                    ),
                  );
                }
                setState(() {});
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
