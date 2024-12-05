import 'package:flutter/material.dart';

import 'package:news/models/article.dart';
import 'package:news/screens/news_detail_screen.dart';
import 'package:news/screens/widgets/news_card.dart';
import 'package:news/services/news_service.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = true;

  bool _validateArticle(Article article) {
    return article.title != null &&
        article.urlToImage != null &&
        article.url != null &&
        article.content != null;
  }

  Future<void> _loadNews() async {
    try {
      final response = await _newsService.fetchTopHeadlines();
      setState(() {
        _articles = response.where(_validateArticle).toList();
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

  void _goToNewsDetail(article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewsDetailScreen(
          article: article,
        ),
      ),
    );
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

          return GestureDetector(
            onTap: () {
              _goToNewsDetail(article);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: NewsCard(
                article: article,
              ),
            ),
          );
        },
      ),
    );
  }
}
