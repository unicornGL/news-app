import 'package:flutter/material.dart';

class NavItem {
  static const List<NavItem> items = [
    NavItem._internal(
      title: 'Top News',
      icon: Icons.newspaper,
      label: 'Top News',
    ),
    NavItem._internal(
      title: 'Categories',
      icon: Icons.category,
      label: 'Categories',
    ),
    NavItem._internal(
      title: 'Read-Later',
      icon: Icons.hourglass_bottom,
      label: 'Read-Later',
    ),
    NavItem._internal(
      title: 'Search',
      icon: Icons.search,
      label: 'Search',
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
