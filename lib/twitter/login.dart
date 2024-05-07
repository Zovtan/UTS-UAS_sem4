import 'package:flutter/material.dart';
import 'package:twitter/class/profiles.dart';
import 'package:twitter/twitter/main_page.dart';
import 'package:twitter/twitter/sign_in.dart';

class Login extends StatefulWidget {
  final ProfileData profileData;

  const Login({super.key, required this.profileData});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late ProfileData profileData;
  TextEditingController identifierController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  String currUsername = "";
  String currDisplayname = "";
  int currId = 0;

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(
          'assets/images/twitterXlogo.avif',
          height: 30,
          width: 30,
        ),
      ),
      body: SingleChildScrollView(
        //textfield
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100.0),
              const Text(
                "What's happening?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(height: 20.0),
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: identifierController,
                decoration: const InputDecoration(
                  labelText: "Phone, email, or username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible; //update true -> false -> true -> ...
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              
              //login
              ElevatedButton(
                onPressed: () {
                  String identifier =
                      identifierController.text.trim().toLowerCase();
                  String password = passwordController.text.trim();

                  bool isValid = false;
                  for (var profile in profileData.profiles) {
                    if ((profile.email == identifier ||
                            profile.username == "@$identifier" || //cek pakai @
                            profile.phone == identifier) &&
                        profile.password == password) {
                      isValid = true;
                      currUsername = profile.username;
                      currDisplayname = profile.displayName;
                      currId = profile.id;
                      break;
                    }
                  }

                  if (isValid) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          currId: currId,
                          currUsername: currUsername,
                          currDisplayName: currDisplayname,
                          profileData: profileData,
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email or password is incorrect'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(),
                child: const Text(
                  'Login',
                ),
              ),

              //sign in
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(
                        profileData: profileData,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Sign In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
