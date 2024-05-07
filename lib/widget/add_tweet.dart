import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class AddTweetPage extends StatefulWidget {
  final Function(String) onTweetAdded;
  final String currDisplayName;

  const AddTweetPage({
    super.key,
    required this.onTweetAdded,
    required this.currDisplayName,
  });

  @override
  State<AddTweetPage> createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  late TextEditingController _tweetController;
  String newTweet = '';

  @override
  void initState() {
    super.initState();
    _tweetController = TextEditingController();
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
              // larang kirim jika isi tweet kosong
              if (newTweet.isNotEmpty) {
                widget.onTweetAdded(newTweet);
                Navigator.of(context).pop(); // tutup page
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
      //textfield
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

  //hapus isi tweetController saat keluar
  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }
}

