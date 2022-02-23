import 'package:flutter/material.dart';
import 'package:news_app/views/favorites.dart';
import 'package:news_app/views/home.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);
  int currentIndex;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          widget.currentIndex = index;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          setState(() {
            widget.currentIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Favorites()),
          );
        }
      },
      currentIndex: widget.currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), title: Text('Favorites'))
      ],
    );
  }
}
