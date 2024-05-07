import 'package:flutter/material.dart';
import 'package:twitter/class/profiles.dart';
import 'package:twitter/twitter/login.dart';

class SignIn extends StatefulWidget {
  final ProfileData profileData;

  const SignIn({super.key, required this.profileData});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late ProfileData profileData;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
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
              const Text(
                "Create your account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: repeatPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Repeat Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              //tombol submit
              ElevatedButton(
                onPressed: () {
                  bool isValid = true;
                  String email = emailController.text.trim().toLowerCase();
                  String username =
                      usernameController.text.trim().toLowerCase();
                  String phone = phoneController.text.trim();
                  String password = passwordController.text.trim();
                  String repeatPassword = repeatPasswordController.text.trim();
                  bool isEmailValid =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(email);

                  // Cek apakah ada username
                  if (username.isEmpty || displayNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please provide an username and a display name.'),
                      ),
                    );
                    return;
                  }

                  // cek apakah email dan phone kosong
                  if (email.isEmpty && phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide either email or phone.'),
                      ),
                    );
                    return;
                  }

                  // cek apakah email valid
                  if (email.isNotEmpty && !isEmailValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide a valid email.'),
                      ),
                    );
                    return;
                  }

                  //cek apakah ada password
                  if (password.isEmpty || repeatPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please provide a password and repeat it.'),
                      ),
                    );
                    return;
                  }

                  // cek apakah password dan repeatpassword sama
                  if (password != repeatPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match.'),
                      ),
                    );
                    return;
                  }

                  //cek apakah profile tersedia
                  for (var profile in profileData.profiles) {
                    if ((profile.email == email && email.isNotEmpty) ||
                        (profile.phone == phone && phone.isNotEmpty) ||
                        profile.username == username) {
                      isValid = false;
                      break;
                    }
                  }

                  //jika semua valid
                  if (isValid) {
                    profileData.addProfile(Profile(
                      id: profileData.profiles.length + 1,
                      username: "@$username", //tambahkan @
                      displayName: displayNameController.text.trim(),
                      email: email,
                      phone: phone,
                      password: password,
                    ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(
                          profileData: profileData,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Email, username, or Phone number is taken'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
