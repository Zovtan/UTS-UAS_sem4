import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              // Add the new tweet and close the page
              if (newTweet.isNotEmpty) {
                widget.onTweetAdded(
                    newTweet); // panggil fungsi onTweetAdded dari mainpage lalu kirim balik newTweet
                Navigator.of(context).pop(); // Close the page
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Set rounded corners here
              ),
            ),
            child: Text(
              "Post",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Container(
              width: 35,
              margin: EdgeInsetsDirectional.only(end: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePicture(
                    name: widget.currDisplayName,
                    radius: 31,
                    fontsize: 10,
                    count: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    autofocus: true, //otomatis menunjukkan keyboard
                    keyboardType: TextInputType.text,
                    maxLines: null, // supaya bisa auto enter saat text overflow
                    decoration: InputDecoration(
                        hintText: "What's happening?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 101, 119, 134))),
                    onChanged: (value) {
                      setState(() {
                        newTweet = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
