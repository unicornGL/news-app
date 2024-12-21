import 'package:flutter/material.dart';

import 'package:news/models/article.dart';
import 'package:news/screens/widgets/news_list.dart';
import 'package:news/services/news_service.dart';
import 'package:news/utils/article_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _newsService = NewsService();
  final _searchController = TextEditingController();

  List<Article> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _search(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return;

    setState(() {
      _searchResults = [];
      _error = null;
      _isLoading = true;
    });

    try {
      final response = await _newsService.searchNews(trimmedQuery);
      setState(() {
        _searchResults = response.where(validateArticle).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
        _isLoading = false;
      });
    }
  }

  Widget get searchContent {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_searchResults.isNotEmpty) {
      return NewsList(articles: _searchResults);
    }

    if (_searchController.text.isNotEmpty) {
      return const Center(
        child: Text('No news found.'),
      );
    }

    return const Center(
      child: Text('Enter keywords to start searching.'),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search News...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _search('');
                            _searchResults = [];
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (_) {
                setState(() {});
              },
              onSubmitted: (value) {
                _search(value);
              },
            ),
          ),
          Expanded(
            child: searchContent,
          )
        ],
      ),
    );
  }
}
