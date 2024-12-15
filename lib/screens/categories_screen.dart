import 'package:flutter/material.dart';

final List<String> dummyCategories = [
  'business',
  'entertainment',
  'general',
  'health',
  'science',
  'sports',
  'technology',
];

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
        itemCount: dummyCategories.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {},
            child: Text(
              dummyCategories[index],
            ),
          );
        },
      ),
    );
  }
}
