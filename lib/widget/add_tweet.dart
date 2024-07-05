import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:twitter/model/tweets_mdl.dart';
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
  int? currUserId;

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController();
    _loadCurrId();
  }

  Future<void> _loadCurrId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currUserId = prefs.getInt('currUserId');
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
                  Consumer<TweetProvider>(
                    builder: (context, tweetProvider, _) {
                      if (tweetProvider.isLoading) {
                        return const CircularProgressIndicator();
                      } else if (tweetProvider.hasError) {
                        return Text('Error loading tweets');
                      } else {
                        return const SizedBox(); // Or any other default content
                      }
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
    if (currUserId != null) {
      TweetMdl newTweet = TweetMdl(
        twtId: 0, // Adjust this according to your backend logic or generate unique IDs
        userId: currUserId!,
        username: widget.currUsername,
        displayName: widget.currDisplayName,
        tweet: _tweetController.text,
        image: "none",
        timestamp: DateTime.now().toIso8601String(),
        likes: 0,
        retweets: 0,
        qtweets: 0,
        views: 0,
        bookmarks: 0,
        commentCount: 0,
        interactions: Interactions(
    isLiked: false,
    isRetweeted: false,
    isBookmarked: false,
  ),
      );

      Provider.of<TweetProvider>(context, listen: false).addTweet(newTweet);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
    }
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }
}

