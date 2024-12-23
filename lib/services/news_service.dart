import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:news/models/article.dart';
import 'package:news/providers/categories_provider.dart';

class NewsService {
  static const String baseUrl = 'https://newsapi.org/v2';
  // TODO: use dotenv
  static const String apiKey = '8d1cf0c03e844d159b5b9cbfcd9236b4';

  Future<List<Article>> fetchTopHeadlinesByCountry(String country) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey'),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load top headlines by country: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<Article>> fetchTopHeadlinesByCategory(Category category) async {
    try {
      final res = await http.get(
        Uri.parse(
            '$baseUrl/top-headlines?category=${category.name}&apiKey=$apiKey'),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load top headlines by category: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<Article>> searchNews(String query) async {
    try {
      final res = await http.get(
        Uri.parse(
            '$baseUrl/everything?q=$query&sortBy=relevancy&apiKey=$apiKey'),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        throw Exception('Failed to search news: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
