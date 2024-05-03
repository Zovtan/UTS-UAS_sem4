import 'package:flutter/material.dart';

class TwitterBottomBar extends StatelessWidget {
  const TwitterBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(120, 101, 119, 134),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // supaya g mencong icons nya
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 101, 119, 134),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}
