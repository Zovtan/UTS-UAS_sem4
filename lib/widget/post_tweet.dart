import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class AddTweetPage extends StatefulWidget {
  final Function(String) onTweetAdded;
  final String currDisplayName;

  const AddTweetPage(
      {Key? key, required this.onTweetAdded, required this.currDisplayName})
      : super(key: key);

  @override
  State<AddTweetPage> createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  String newTweet = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [
          TextButton(
              onPressed: () {
                // Add the new tweet and close the page
                if (newTweet.isNotEmpty) {
                  widget.onTweetAdded(
                      newTweet); // panggil fungsi onTweetAdded dari mainpage lalu kirim balik newTweet
                  Navigator.of(context).pop(); // Close the page
                }
              },
              child: Text("Post"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfilePicture(
              name: widget.currDisplayName,
              radius: 31,
              fontsize: 21,
              random: true,
              count: 2,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  newTweet = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
