import 'package:flutter/material.dart';

import 'package:news/models/article.dart';
import 'package:news/screens/news_detail_screen.dart';
import 'package:news/screens/widgets/news_card.dart';

class NewsList extends StatelessWidget {
  const NewsList({
    super.key,
    required this.articles,
  });

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    void goToNewsDetail(article) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => NewsDetailScreen(
            article: article,
          ),
        ),
      );
    }

    return ListView.separated(
      key: const PageStorageKey('news_list'),
      itemCount: articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (ctx, index) {
        final article = articles[index];

        return GestureDetector(
          onTap: () {
            goToNewsDetail(article);
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
    );
  }
}
