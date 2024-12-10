import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:news/models/article.dart';

class ToReadService {
  static const _storageKey = 'to_read';

  Future<void> saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final currentToReads = await getToReadArticles();

    if (currentToReads
        .any((currentToRead) => currentToRead.url == article.url)) {
      return;
    }

    currentToReads.add(article);

    final articleJsonList =
        currentToReads.map((article) => article.toJson()).toList();

    await prefs.setString(_storageKey, json.encode(articleJsonList));
  }

  Future<void> removeArticle(String? url) async {
    if (url == null) return;

    final prefs = await SharedPreferences.getInstance();
    final List<Article> currentToReads = await getToReadArticles();

    currentToReads.removeWhere((currentToRead) => currentToRead.url == url);

    final articleJsonList =
        currentToReads.map((article) => article.toJson()).toList();

    await prefs.setString(_storageKey, json.encode(articleJsonList));
  }

  Future<List<Article>> getToReadArticles() async {
    final prefs = await SharedPreferences.getInstance();

    String? articleJsonString = prefs.getString(_storageKey);

    if (articleJsonString == null || articleJsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> articleJsonList = json.decode(articleJsonString);
      return articleJsonList
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> checkIsInToRead(String? url) async {
    if (url == null) {
      return false;
    }

    final List<Article> articles = await getToReadArticles();
    return articles.any((article) => article.url == url);
  }
}
