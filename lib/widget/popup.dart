import 'package:flutter/material.dart';

class AddTweetPopup extends StatelessWidget {
  final Function(String) onTweetAdded;

  const AddTweetPopup({Key? key, required this.onTweetAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newTweet = '';

    return AlertDialog(
      title: Text('Add New Tweet'),
      content: TextField(
        keyboardType: TextInputType.text,
        onChanged: (value) {
          newTweet = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter your tweet here',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Add the new tweet and close the dialog
            if (newTweet.isNotEmpty) {
              onTweetAdded(newTweet);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
