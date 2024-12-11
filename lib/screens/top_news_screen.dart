import 'package:flutter/material.dart';

import 'package:news/models/article.dart';
import 'package:news/screens/widgets/news_list.dart';
import 'package:news/services/news_service.dart';
import 'package:news/utils/article_utils.dart';

class TopNewsScreen extends StatefulWidget {
  const TopNewsScreen({super.key});

  @override
  State<TopNewsScreen> createState() => _TopNewsScreenState();
}

class _TopNewsScreenState extends State<TopNewsScreen> {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = true;

  Future<void> _loadNews() async {
    try {
      final response = await _newsService.fetchTopHeadlines();
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
      child: NewsList(
        articles: _articles,
      ),
    );
  }
}
