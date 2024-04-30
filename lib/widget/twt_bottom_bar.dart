import 'package:flutter/material.dart';

class TwitterBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(120, 101, 119, 134), // Border color
            width: 1.0, // Border width
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // supaya g mencong icons nya
        selectedItemColor: Colors.blue,
        unselectedItemColor: Color.fromARGB(255, 101, 119, 134),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
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
