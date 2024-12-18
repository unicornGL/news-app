import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Category {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology,
}

class CategoriesNotifier extends StateNotifier<Category?> {
  CategoriesNotifier() : super(null);

  bool isSelected(Category category) => state == category;

  void selectCategory(Category category) {
    state = isSelected(category) ? null : category;
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, Category?>(
  (ref) => CategoriesNotifier(),
);
