import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:news/models/article.dart';

class NewsService {
  static const String baseUrl = 'https://newsapi.org/v2';
  // TODO: use dotenv
  static const String apiKey = '8d1cf0c03e844d159b5b9cbfcd9236b4';

  Future<List<Article>> fetchTopHeadlines() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to load news: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
