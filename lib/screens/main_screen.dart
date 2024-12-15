import 'package:flutter/material.dart';

import 'package:news/models/nav_item.dart';
import 'package:news/screens/categories_screen.dart';
import 'package:news/screens/search_screen.dart';
import 'package:news/screens/to_read_screen.dart';
import 'package:news/screens/top_news_screen.dart';

enum Screen {
  topNews,
  categories,
  toRead,
  search,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Screen _currentScreenEnum = Screen.topNews;
  Widget _currentScreen = const TopNewsScreen();

  void _selectScreen(Screen screen) {
    _currentScreenEnum = screen;

    setState(() {
      switch (screen) {
        case Screen.topNews:
          _currentScreen = const TopNewsScreen();
          break;
        case Screen.categories:
          _currentScreen = const CategoriesScreen();
          break;
        case Screen.toRead:
          _currentScreen = const ToReadScreen();
          break;
        case Screen.search:
          _currentScreen = const SearchScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          NavItem.items[_currentScreenEnum.index].title,
        ),
      ),
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreenEnum.index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _selectScreen(Screen.values[index]);
        },
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
