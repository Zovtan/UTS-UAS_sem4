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
  late ProfileData profileData; //late di pakai jika ingin mendeklarasi variable yg akan diinisialisasi nanti (value ditambah nanti)
  TextEditingController identifierController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  String currUsername = "";
  String currDisplayname = "";

//reset parameter saat keluar dari app
  @override
  void initState() {
    super.initState();
     profileData = widget.profileData;
    identifierController;
    passwordController;
    passwordVisible = false;
    currUsername = "";
    currDisplayname = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            controller: identifierController,
            decoration: const InputDecoration(
              labelText: "Phone Number, Username, or Email",
            ),
          ),
          TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            controller: passwordController,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
          ),
          //tombol login
          ElevatedButton(
            onPressed: () {
              String identifier =
                  identifierController.text.trim().toLowerCase();
              String password = passwordController.text.trim();

              // Validation logic
              bool isValid = false;
              for (var profile in profileData.profiles) {
                if ((profile.email == identifier ||
                        profile.username == identifier ||
                        profile.phone == identifier) &&
                    profile.password == password) {
                  isValid = true;
                  currUsername = profile.username;
                  currDisplayname = profile.displayName;

                  break;
                }
                print(profile.email);
                print(profile.username);
                print(profile.phone);
                print(identifierController);
                print(profile.password);
                print(passwordController);
              }

              if (isValid) {
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
                    builder: (context) => SignIn(profileData: profileData,),
                  ),
                );
              },
              child: const Text('Sign In'))
        ],
      ),
    );
  }
}
