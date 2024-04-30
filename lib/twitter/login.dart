import 'package:flutter/material.dart';
import 'package:twitter/class/profiles.dart';
import 'package:twitter/twitter/main_page.dart';
import 'package:twitter/twitter/sign_in.dart';

class Login extends StatefulWidget {
  final ProfileData profileData;

  const Login({Key? key, required this.profileData}) : super(key: key);

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
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100.0),
              Text("What's happening?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
              SizedBox(height: 20.0),
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: identifierController,
                decoration: InputDecoration(
                  labelText: "Phone, email, or username",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.0),
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
                      break;
                    }
                  }

                  if (isValid) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          currUsername: currUsername,
                          currDisplayName: currDisplayname,
                          profileData: profileData,
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email or password is incorrect'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Login',
                ),
                style: ElevatedButton.styleFrom(),
              ),
              SizedBox(height: 10.0),
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
                child: Text(
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
