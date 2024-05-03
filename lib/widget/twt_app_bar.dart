import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:twitter/twitter/login.dart';
import 'package:twitter/class/profiles.dart';

class TwitterAppBar extends StatelessWidget {
  final String currDisplayName;
  final ProfileData profileData;

  const TwitterAppBar(
      {super.key, required this.currDisplayName, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation:
          0, //menghilangkan efek ganti warna saat ada item dibawah appbar
      backgroundColor: Colors.black,
      elevation: 0,
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(profileData: profileData),
                        ),
                        (route) => false,
                      );
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
          name: currDisplayName,
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
      floating: true,
      snap: true,
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
                        color: Colors.blue, // Border color
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
    );
  }
}
