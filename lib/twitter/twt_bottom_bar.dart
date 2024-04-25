import 'package:flutter/material.dart';

class TwitterBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //harus pakai ini kalo mau ganti warna
      backgroundColor: const Color.fromRGBO(30, 33, 41, 1),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: "",
        ),
      ],
      showSelectedLabels: false,
showUnselectedLabels: false,
      unselectedItemColor: Colors.white,
      selectedItemColor:
          const Color.fromRGBO(37, 157, 253, 1),
    );
  }
}
