import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:news/providers/categories_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categoriesProvider);

    void selectCategory(Category category) {
      print(category.name);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
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
                final isSelected =
                    ref.read(categoriesProvider.notifier).isSelected(category);

                return OutlinedButton(
                  onPressed: () {
                    ref
                        .read(categoriesProvider.notifier)
                        .selectCategory(category);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    foregroundColor: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    side: BorderSide(
                      color: isSelected
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
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
          FilledButton(
            onPressed: selectedCategory == null
                ? null
                : () {
                    selectCategory(selectedCategory);
                  },
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
