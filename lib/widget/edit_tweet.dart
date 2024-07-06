import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class EditTweetPage extends StatefulWidget {
  final String currDisplayName;
  final String tweet;
  final Function(String) onTweetEdited;

  const EditTweetPage(
      {Key? key, required this.currDisplayName, required this.tweet, required this.onTweetEdited});

  @override
  EditTweetPageState createState() => EditTweetPageState();
}

class EditTweetPageState extends State<EditTweetPage> {
  late TextEditingController _tweetController;
  bool isLoading = false; // Add isLoading state

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController(text: widget.tweet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Edit Tweet'),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    // Disable button when isLoading is true
                    setState(() {
                      isLoading =
                          true; // Set isLoading to true before async operation
                    });

                    final editedTweet = _tweetController.text.trim();
                    if (editedTweet.isEmpty) {
                      _showSnackBar(context, "Tweet cannot be empty");
                    } else {
                      await widget.onTweetEdited(editedTweet);
                      _showSnackBar(context, "Tweet edited");
                      Navigator.of(context).pop();
                    }

                    setState(() {
                      isLoading =
                          false; // Set isLoading back to false after async operation completes
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator() // Show loading indicator when isLoading is true
                : const Text(
                    'Save Changes',
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              child: TextField(
                autofocus: true,
                controller: _tweetController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Don't leave edited tweet empty",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 101, 119, 134),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
