import 'package:flutter/material.dart';

import 'package:news/models/article.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 12,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.urlToImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    article.title!,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    article.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
