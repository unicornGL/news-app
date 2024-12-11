import 'package:news/models/article.dart';

bool validateArticle(Article article) {
  return article.title != null &&
      article.urlToImage != null &&
      article.url != null &&
      article.content != null;
}
