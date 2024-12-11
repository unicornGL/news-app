import 'package:flutter/material.dart';

import 'package:news/models/nav_item.dart';
import 'package:news/screens/search_screen.dart';
import 'package:news/screens/to_read_screen.dart';
import 'package:news/screens/top_news_screen.dart';

enum Screens {
  topNews,
  search,
  toRead,
  favorites,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedBottomNavIndex = 0;
  Widget _currentScreen = const TopNewsScreen();

  void _selectScreen(screenIndex) {
    setState(() {
      _selectedBottomNavIndex = screenIndex;

      switch (_selectedBottomNavIndex) {
        case 0:
          _currentScreen = const TopNewsScreen();
          break;
        case 1:
          _currentScreen = const SearchScreen();
          break;
        case 2:
          _currentScreen = const ToReadScreen();
        default:
      }
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
      body: _currentScreen,
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
