import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:news/models/article.dart';
import 'package:news/providers/categories_provider.dart';
import 'package:news/screens/widgets/news_list.dart';
import 'package:news/services/news_service.dart';
import 'package:news/utils/article_utils.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = false;

  Future<void> _loadNews(Category category) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _newsService.fetchTopHeadlinesByCategory(category);
      setState(() {
        _articles = response.where(validateArticle).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to load news, please try again later.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              _loadNews(category);
            },
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final category = ref.read(categoriesProvider);
      if (category != null) {
        _loadNews(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(categoriesProvider, (_, newCategory) {
      if (newCategory != null) {
        _loadNews(newCategory);
      }
    });

    Widget categoryContent() {
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (_articles.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('There is no news right now.'),
            ],
          ),
        );
      }

      return NewsList(articles: _articles);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 240,
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
          Expanded(
            child: categoryContent(),
          ),
        ],
      ),
    );
  }
}
