import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news/models/article.dart';
import 'package:news/providers/to_read_provider.dart';
import 'package:news/screens/widgets/news_list.dart';
import 'package:news/services/to_read_service.dart';

class ToReadScreen extends ConsumerStatefulWidget {
  const ToReadScreen({super.key});

  @override
  ConsumerState<ToReadScreen> createState() => _ToReadScreenState();
}

class _ToReadScreenState extends ConsumerState<ToReadScreen> {
  final ToReadService _toReadService = ToReadService();
  List<Article> _articles = [];
  bool _isLoading = true;

  Future<void> _loadToReads() async {
    final articles = await _toReadService.getToReadArticles();

    setState(() {
      _articles = articles;
      _isLoading = false;
    });

    ref.read(toReadRefreshProvider.notifier).state = false;
  }

  @override
  void initState() {
    super.initState();
    _loadToReads();
  }

  @override
  Widget build(BuildContext context) {
    final shouldRefresh = ref.watch(toReadRefreshProvider);

    if (shouldRefresh) {
      Future.microtask(() => _loadToReads());
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_articles.isEmpty) {
      return const Center(
        child: Text('Add some news to read later.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadToReads,
      child: NewsList(
        articles: _articles,
      ),
    );
  }
}
