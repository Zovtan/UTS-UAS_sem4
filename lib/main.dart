import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/provider/comment_prov.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:twitter/provider/profile_prov.dart';
import 'package:twitter/screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => TweetProvider()),
        ChangeNotifierProvider(create: (context) => CommentProvider()),
      ],
      child: MaterialApp(
        title: 'Twitter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            background: Colors.black,
            seedColor: const Color.fromARGB(255, 29, 161, 242),
            tertiary: const Color.fromARGB(255, 101, 119, 134),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const Login(),
      ),
    );
  }
}
