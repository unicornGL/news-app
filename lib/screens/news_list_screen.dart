import 'package:flutter/material.dart';
import 'package:news/screens/widgets/news_card.dart';

import 'package:news/services/news_service.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService _newsService = NewsService();
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  bool _validateArticle(Map<String, dynamic> article) {
    return article['title'] != null &&
        article['description'] != null &&
        article['urlToImage'] != null &&
        article['content'] != null;
  }

  Future<void> _loadNews() async {
    try {
      final response = await _newsService.fetchTopHeadlines();
      setState(() {
        _articles = List<Map<String, dynamic>>.from(response['articles'])
            .where(_validateArticle)
            .toList();
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
            onPressed: _loadNews,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
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

    return RefreshIndicator(
      onRefresh: _loadNews,
      child: ListView.separated(
        key: const PageStorageKey('news_list'),
        itemCount: _articles.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (ctx, index) {
          final article = _articles[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: NewsCard(
              article: article,
            ),
          );
        },
      ),
    );
  }
}
