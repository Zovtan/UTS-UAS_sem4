import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TwitterAppBar extends StatefulWidget {
  final String currDisplayName;

  const TwitterAppBar({super.key, required this.currDisplayName});

  @override
  TwitterAppBarState createState() => TwitterAppBarState();
}

class TwitterAppBarState extends State<TwitterAppBar> {
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); //hapus sharedPreference

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0, //menghilangkan efek ganti warna saat ada item dibawah appbar
      backgroundColor: Colors.black,
      elevation: 0,
      floating: true,
      snap: true, //ini yg menyembunyikan appbar saat scrolling
      centerTitle: true,
      title: Image.asset(
        'assets/images/twitterXlogo.avif',
        height: 30,
        width: 30,
      ),
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16),
                ),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _logout();
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: ProfilePicture(
          name: widget.currDisplayName,
          radius: 12,
          fontsize: 10,
          count: 2,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(120, 101, 119, 134),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.blue,
                        width: 5),
                  ),
                ),
                child: const Text(
                  'For you',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Text(
                'Following',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      flexibleSpace: _isLoading
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : null,
    );
  }
}
