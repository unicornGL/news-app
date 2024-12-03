import 'package:flutter/material.dart';

class NavItem {
  static const List<NavItem> items = [
    NavItem._internal(
      title: 'Top News',
      icon: Icons.newspaper,
      label: 'Top News',
    ),
    NavItem._internal(
      title: 'Search',
      icon: Icons.search,
      label: 'Search',
    ),
    NavItem._internal(
      title: 'To-Watch',
      icon: Icons.hourglass_bottom,
      label: 'To-Watch',
    ),
    NavItem._internal(
      title: 'Favorites',
      icon: Icons.star,
      label: 'Favorites',
    ),
  ];

  const NavItem._internal({
    required this.title,
    required this.icon,
    required this.label,
  });

  final String title;
  final IconData icon;
  final String label;
}
