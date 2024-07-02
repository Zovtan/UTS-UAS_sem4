import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:twitter/class/tweets.dart';
import 'package:twitter/provider/tweet_prov.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTweetPage extends StatefulWidget {
  final String currUsername;
  final String currDisplayName;

  const AddTweetPage({
    Key? key,
    required this.currUsername,
    required this.currDisplayName,
  }) : super(key: key);

  @override
  State<AddTweetPage> createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  late TextEditingController _tweetController;
  String newTweet = '';
  int? currId;

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController();
    _loadCurrId();
  }

  Future<void> _loadCurrId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currId = prefs.getInt('currUserId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              // Prevent posting if tweet is empty
              if (newTweet.isNotEmpty) {
                _addTweet(context);
                Navigator.of(context).pop(); // Close page
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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
              margin: const EdgeInsetsDirectional.only(end: 10),
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
                    controller: _tweetController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "What's happening?",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 101, 119, 134),
                      ),
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
          ],
        ),
      ),
    );
  }

  void _addTweet(BuildContext context) {
    if (currId != null) {
      Provider.of<TweetProvider>(context, listen: false).addTweet(
        Tweet(
          twtId: Provider.of<TweetProvider>(context, listen: false).tweets.length + 1,
          userId: currId!,
          username: widget.currUsername,
          displayName: widget.currDisplayName,
          tweet: newTweet,
          image: "none",
          timestamp: DateTime.now().toIso8601String(),
          likes: 0,
          retweets: 0,
          qtweets: 0,
          views: 0,
          bookmarks: 0,
          commentCount: 0,
        ),
      );
    } else {
      // Handle the case where currId is not loaded yet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found')),
      );
    }
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }
}
