import 'package:flutter/material.dart';

import 'package:news/models/nav_item.dart';
import 'package:news/screens/news_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedBottomNavIndex = 0;

  void _selectScreen(screenIndex) {
    setState(() {
      _selectedBottomNavIndex = screenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          NavItem.items[_selectedBottomNavIndex].title,
        ),
      ),
      body: const NewsListScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _selectScreen,
        items: NavItem.items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
