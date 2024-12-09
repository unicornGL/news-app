import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news/providers/to_read_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:news/services/to_read_service.dart';
import 'package:news/models/article.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  const NewsDetailScreen({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  final ToReadService _toReadService = ToReadService();
  bool _isInToRead = false;

  @override
  void initState() {
    super.initState();
    _checkIsInToRead();
  }

  Future<void> _checkIsInToRead() async {
    final isInToRead = await _toReadService.checkIsInToRead(widget.article.url);
    setState(() {
      _isInToRead = isInToRead;
    });
  }

  Future<void> _toggleToRead() async {
    if (_isInToRead) {
      await _toReadService.removeArticle(widget.article.url);

      ref.read(toReadRefreshProvider.notifier).state = true;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Remove from to-read.',
          ),
        ),
      );
      setState(() {
        _isInToRead = false;
      });
    } else {
      await _toReadService.saveArticle(widget.article);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Add to to-read.',
          ),
        ),
      );
      setState(() {
        _isInToRead = true;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Unable to open the news article.',
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.amber,
            onPressed: () => _launchUrl(context, widget.article.url!),
          ),
          backgroundColor: Colors.grey[850],
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        actions: [
          IconButton(
            onPressed: _toggleToRead,
            icon: Icon(
              _isInToRead ? Icons.hourglass_full : Icons.hourglass_empty,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.urlToImage != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  widget.article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.article.author?.isNotEmpty == true) ...[
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.article.author!,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (widget.article.publishedAt?.isNotEmpty == true) ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.article.publishedAt!),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.article.content!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _launchUrl(context, widget.article.url!);
                      },
                      icon: const Icon(Icons.launch),
                      label: Text(
                        'Read Full Story on ${widget.article.source?.name ?? "Source"}',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
