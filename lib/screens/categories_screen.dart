import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

enum Category {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology,
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Category? _selectedCategory;

  bool _isSelected(category) => _selectedCategory == category;

  void _selectCategory(Category category) {
    setState(() {
      _selectedCategory = _isSelected(category) ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 16,
        ),
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          final category = Category.values[index];

          return OutlinedButton(
            onPressed: () {
              _selectCategory(Category.values[index]);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: _isSelected(category)
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              foregroundColor: _isSelected(category)
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              side: BorderSide(
                color: _isSelected(category)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withOpacity(.3),
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              toBeginningOfSentenceCase(category.name),
              style: TextStyle(
                fontWeight:
                    _isSelected(category) ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
